module Muvandy
  module Helpers
    def show_version(variable_key, fallback_text=nil)
      begin
        @current_muvandy_visitor.variable_version(variable_key)
      rescue
        return (fallback_text.nil?) ? '{place_holder}' : fallback_text
      end
    end
  end
end