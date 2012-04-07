# Muvandy

Client for Muvandy API

## Installation

Add this line to your application's Gemfile:

		gem 'muvandy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install muvandy

## Configure

Create a file in your config/initializers folder named muvandy_setup.rb (or whichever name you prefer)

 		Muvandy.configure do |c|
			c.api_key = '<place your api key here>'
		end

## Usage

In your Controller.

		class HomeController < ApplicationController
			include Muvandy
			before_filter :set_muvandy_info, :only => [:index]
			
			def index
				@muvandy = Muvandy.new('experiment-id')
			end
		end

On views/home/index.html.erb

		<%= content_tag "h1", @muvandy.get_variation("Headline-1", "Greetings!") %>  # 2nd parameters serves asa default.
		<p>
			<%= @muvandy.get_variation("main-text-1") %>
		</p>

