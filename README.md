# Muvandy

Client for [Muvandy API](http://muvandy.com)

## Installation

Add this line to your application's Gemfile:

		gem 'muvandy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install muvandy

## To Configure

Create a file in your config/initializers folder named muvandy_setup.rb (or whichever name you prefer)

 		Muvandy.configure do |c|
			c.api_key = '<place your api key here>'
		end

## Get Variations

### Controller

Example of using muvandy on a controller. 

		class HomeController < ApplicationController
			include Muvandy
			before_filter :set_muvandy_info, :only => [:index]
			
			def index
				@muvandy = Muvandy.new('experiment-id', :visitor_key => request.remote_ip)
			end
		end

A 'visitor_key' is required. You can use the visitor's IP address, email or any unique identifier for the user in your app. 

### Views

		<%= content_tag "h1", @muvandy.get_variation("Headline-1", "Greetings!") %>
		<p>
			<%= @muvandy.get_variation("main-text-1") %>
		</p>

An optional second parameter for 'get_variations' method can be provided to serve as a default value.

### Conversions

		class HomeController < ApplicationController
			include Muvandy
			
			...
			
			def thank_you
			
				...
				
				Muvandy::convert('experiment_id', :visitor_key => request.remote_ip)
			end
		end

