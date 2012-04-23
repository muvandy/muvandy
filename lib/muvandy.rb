require "httparty"
require "muvandy/version"
require "muvandy/muvandy"

module Muvandy
  
  def self.included(base)
    base.send(:include, ClassMethods)
  end

  module ClassMethods
    
    def collect_muvandy_visitor_info
      Muvandy.mode = params[:mode]
      Muvandy.utm_term = params[:utm_term]
      Muvandy.utm_campaign = params[:utm_campaign]
      Muvandy.utm_source = params[:utm_source]
      Muvandy.utm_medium = params[:utm_medium]

      Muvandy.referrer = request.referrer
    end 

  end
 
  class << self
    
    attr_accessor :api_key, :site
    
    def configure
      yield self
          
      Muvandy.api_key = api_key
      Muvandy.site = (site.nil?) ? 'http://muvandy.com' : site
    end

  end
  
end
