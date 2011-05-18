module Muvandy
  module Base
    module ClassMethods
      def muvandy_template(slug='')
        proc = Proc.new  do |c| 
           c.instance_variable_set(:@muvandy_tpl_slug, slug)
           c.send :current_muvandy_visitor
         end
         before_filter(proc)
      end
    end

    module InstanceMethods
      def current_muvandy_visitor
        @current_muvandy_visitor ||= muvandy_visitor_init
      end

      def muvandy_visitor_init
        Muvandy::Visitor.new(@muvandy_tpl_slug, [], muvandy_extra_params)
      end

      def visitor_convert
        begin
          current_muvandy_visitor.convert
        rescue Exception => e
          unless HoptoadNotifier.nil? 
            HoptoadNotifier.notify(e)
          end
          Rails.logger.debug { "#{e.message}" }
        end
      end

      def muvandy_extra_params
        { :visitor_ip => request.remote_ip, :referer => request.referer , :params => params}
      end
    end

    def self.included(klass)
      klass.send(:extend, ClassMethods)
      klass.send(:include, InstanceMethods)
    end  
  end
end