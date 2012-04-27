# Muvandy

Client for [Muvandy API](http://muvandy.com)

## Installation

Add this line to your application's Gemfile:

		gem 'muvandy', '~> 1.1.1a1'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install muvandy --pre

## To Configure

Create a file in your config/initializers folder named muvandy_setup.rb (or whichever name you prefer)

 		Muvandy.configure do |c|
			c.api_key = 'api_key_here'
		end

## Get Variations

### Controller

Example of using muvandy on a controller. 

		class HomeController < ApplicationController
			include Muvandy
			before_filter :collect_muvandy_visitor_info, :only => [:index]
			
			def index
				@muvandy = Muvandy.new('experiment_id', :visitor_key => request.remote_ip)
			end
		end

A 'visitor_key' is required. By default, we recommend using the visitor's IP address but if you have other information on them their account id or email address make good unique visitor identifiers.

Setting 'collect_muvandy_visitor_info' in your before_filter helps muvandy collect the following information from your 'request' & 'params' variables.
* referrer
* utm_term
* utm_campaign
* utm_source
* utm_medium
* mode


### Views

Get the value by providing variable key and a fallback text. Fallback text will be displayed if in case muvandy returns an error for the variable.

		<%= content_tag "h1", @muvandy.get_variation("Headline-1", "Greetings!") %>
		<p>
			<%= @muvandy.get_variation("main-text-1") %>
		</p>

### Conversions

		class HomeController < ApplicationController
			include Muvandy
			
			...
			
			def thank_you
			
				...
				
				Muvandy::convert('experiment_id', :visitor_key => request.remote_ip)
			end
		end

