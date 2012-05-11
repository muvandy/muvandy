require "httparty"
require "muvandy/version"
require "muvandy/muvandy"

module Muvandy
  def collect_muvandy_visitor_info
    Muvandy.mode = params[:mode]
    
    cookies[:muvandy_utm_term] = params[:utm_term] if cookies[:muvandy_utm_term].blank? || (!params[:utm_term].blank? && cookies[:muvandy_utm_term] != params[:utm_term])
    Muvandy.utm_term = cookies[:muvandy_utm_term] unless cookies[:muvandy_utm_term].blank?
    
    cookies[:muvandy_utm_campaign] = params[:utm_campaign] if cookies[:muvandy_utm_campaign].blank? || (!params[:utm_campaign].blank? && cookies[:muvandy_utm_campaign] != params[:utm_campaign])
    Muvandy.utm_campaign = cookies[:muvandy_utm_campaign] unless cookies[:muvandy_utm_campaign].blank?
    
    cookies[:muvandy_utm_source] = params[:utm_source] if cookies[:muvandy_utm_source].blank? || (!params[:utm_source].blank? && cookies[:muvandy_utm_source] != params[:utm_source])
    Muvandy.utm_source = cookies[:muvandy_utm_source] unless cookies[:muvandy_utm_source].blank?
    
    cookies[:muvandy_utm_medium] = params[:utm_medium] if cookies[:muvandy_utm_medium].blank? || (!params[:utm_medium].blank? && cookies[:muvandy_utm_medium] != params[:utm_medium])
    Muvandy.utm_medium = cookies[:muvandy_utm_medium] unless cookies[:muvandy_utm_medium].blank?
    
    cookies[:muvandy_referrer] = request.referrer if cookies[:muvandy_referrer].blank? || (cookies[:muvandy_referrer] != request.referrer)
    Muvandy.referrer = cookies[:muvandy_referrer] unless cookies[:muvandy_referrer].blank?
  end  
 
  class << self    
    attr_accessor :api_key, :site
    
    def configure
      yield self          
      Muvandy.api_key = api_key
      Muvandy.site = (site.nil?) ? 'http://api.muvandy.com' : site
    end

    def included(base)
      base.before_filter :collect_muvandy_visitor_info
    end
  end
end
