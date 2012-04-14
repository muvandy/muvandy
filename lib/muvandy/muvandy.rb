module Muvandy
  class Muvandy
    
    include HTTParty
    format :xml
    
    def initialize(experiment_id, options={})
      throw Exception.new("Please configure first.") if Muvandy.api_key.blank?
      throw Exception.new("No given Experiment ID") if experiment_id.nil?
      
      @visitor_key = options[:visitor_key] if !options[:visitor_key].blank?
      
      # For HTTParty
      self.class.base_uri Muvandy.site
      self.class.basic_auth Muvandy.api_key, ''
      
      @experiment_id = experiment_id
      
      gather_extra_params
      
      get_all_variable_variations if options[:skip_variations].blank?
    end

    def get_variation(variable_key, default="")
      (@variable_variations[variable_key].blank?) ? default : @variable_variations[variable_key].html_safe
    end

    def convert!(value=50)
      post(:convert, :value => value)
    end
        
    private
    
    def get_all_variable_variations
      @variable_variations = {}
      begin
        xml = get(:variable_variations)      
        Rails.logger.debug { "DEBUG ------------ #{xml.parsed_response.inspect}" }
        if xml.parsed_response && !xml.parsed_response["visitor"].blank?
          # self.id  = xml.parsed_response["visitor"]["id"].to_i if !xml.parsed_response["visitor"].blank? && !xml.parsed_response["visitor"]["id"].blank?
          xml.parsed_response["visitor"]["variable_variations"]["variable"].each do |v|
            @variable_variations[v["key"]] =  v["value"]
          end
        end
      rescue
      end
    end

    def api_prefix
      "/api/v#{Versionomy.parse(VERSION).major}"
    end

    def get(action, add_to_query={})
      query_string = case action
      when :variable_variations
        "/experiments/#{@experiment_id}/visitors/variable_variations.xml"
      end
      begin
        xml = self.class.get("#{api_prefix}#{query_string}#{extra_params_to_query(add_to_query)}")
        raise Exception.new(xml.parsed_response["error"]["message"]) if xml.response.code != 200
      rescue Exception => e
        Rails.logger.debug { "Muvandy Gem Error: #{e.message}" }
      end
      xml
    end

    def post(action, query={} )
      query_string = case action
      when :convert
        "/experiments/#{@experiment_id}/visitors/convert.xml"
      end
      begin
        xml = self.class.post("#{api_prefix}#{query_string}", :query => query.merge!(:visitor_key => @visitor_key)) # #{extra_params_to_query(add_to_query)}
        raise Exception.new(xml.parsed_response["error"]["message"]) if xml.response.code != 200
      rescue Exception => e
        Rails.logger.debug { "Muvandy Gem Error: #{e.message}" }
      end
      xml
    end
    
    def valid_params
      [ :mode, :visitor_key, :value, :referrer, :utm_term, :utm_campaign, :utm_source, :utm_medium ]
    end
    
    def gather_extra_params
      @extra_params = {}
      @extra_params[:mode] = Muvandy.mode  unless Muvandy.mode.blank?
      @extra_params[:utm_term] = Muvandy.utm_term  unless Muvandy.utm_term.blank?
      @extra_params[:utm_campaign] = Muvandy.utm_campaign  unless Muvandy.utm_campaign.blank?
      @extra_params[:utm_source] = Muvandy.utm_source  unless Muvandy.utm_source.blank?
      @extra_params[:utm_medium] = Muvandy.utm_medium  unless Muvandy.utm_medium.blank?
      @extra_params[:visitor_key] = @visitor_key  unless @visitor_key.blank? #Muvandy.visitor_key.blank?
      @extra_params[:referrer] = Muvandy.referrer  unless Muvandy.referrer.blank?
    end

    def extra_params_to_query(add_to_query={})
      return '' if @extra_params.blank?
      
      query = []
      params = @extra_params.merge(add_to_query)
      valid_params.each do |key|
        query << "#{key}=#{params[key]}" unless params[key].blank?
      end
      (query.empty?) ? '' : "?#{query.join('&')}"
    end

    class << self
      attr_accessor :api_key, 
                    :site,
                    :visitor_key,
                    :referrer,
                    :mode,
                    :utm_term,
                    :utm_campaign,
                    :utm_source,
                    :utm_medium
      
      def convert(experiment_id, options={})
        muvandy = Muvandy.new(experiment_id, options.merge(:skip_variations => true))
        muvandy.convert!
      end
      
    end

  end
end