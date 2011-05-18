require 'httparty'
require 'muvandy/base'
require 'muvandy/helpers'

module Muvandy

  def self.included(klass)
    klass.send(:include, Muvandy::Base)
    klass.send(:helper, Helpers)
  end

  def self.init
    raise "No ActionController" unless defined?(ActionController)
    ActionController::Base.send :include, Muvandy
  end

  class Visitor
    include HTTParty
    format :xml

    attr_accessor :id,
                  :template_slug, 
                  :visitor_ip,
                  :variable_hash
    
    def initialize(template_slug, slugs=[], extra_params={}, fetch_vars=true)
      
      config = YAML.load_file("#{RAILS_ROOT}/config/muvandy.yml")[RAILS_ENV].symbolize_keys rescue {}
      if !config[:url].blank?
        self.class.base_uri "http://#{config[:url]}"
      else
        self.class.base_uri "http://muvandy.com"
      end
      self.class.basic_auth config[:secret], ''
      
      self.template_slug = template_slug      
      self.visitor_ip = extra_params[:visitor_ip]
      fetch_visitor_values(slugs, extra_params) if fetch_vars
    end

    def fetch_visitor_values(slugs=[], extra_params={})
      if @variable_hash.nil? || @variable_hash.empty?  
        params = extra_params[:params]
        query_params = {
          :visitor_ip => extra_params[:ip_address],
          :referrer => extra_params[:referrer],
          :mode => params[:mode],           
          :utm_term => params[:utm_term],
          :utm_campaign => params[:utm_campaign],
          :utm_source => params[:utm_source],
          :utm_medium => params[:utm_medium]          
        }
        begin
          xml = self.class.get("/tests/#{self.template_slug}/visitors/variable_versions.xml?#{slugs.map{|i| "keys[]=#{i}"}.join("&") unless slugs.empty?}#{hash_to_query_string(query_params)}")

          if xml.parsed_response && !xml.parsed_response["visitor"].blank? #&& !xml.parsed_response["visitor"]["variable_versions"].blank?
            @variable_hash = {}
            self.id  = xml.parsed_response["visitor"]["id"].to_i if !xml.parsed_response["visitor"].blank? && !xml.parsed_response["visitor"]["id"].blank?
            xml.parsed_response["visitor"]["variable_versions"]["variable"].each do |v|
              @variable_hash[v["key"]] =  v["value"]
            end
          end
        rescue
          Rails.logger.debug { "ERROR: #{Problem encountered connecting to Muvandy API}" }
        end
      end
      @variable_hash
    end

   
    def variable_version(slug)
      @variable_hash[slug]
    end    

    def convert
      xml = self.class.get("/tests/#{self.template_slug}/visitors/convert?visitor_ip=#{self.visitor_ip}&value=50")
    end
    
    protected
    
    def hash_to_query_string(hash)
      "&#{hash.map{|key,value| "#{key}=#{value}"}.join("&")}" unless hash.blank?
    end

  end
  
end