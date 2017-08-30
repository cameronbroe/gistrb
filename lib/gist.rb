require 'net/http'
require 'net/https'
require 'highline/import'
require 'json'
require 'clipboard'

# Library requires
require 'gist/user'
require 'gist/post'
require 'gist/helpers'
require 'gist/clipboard'

require_relative './config.rb'

module Gist
	# Module level constants
	API_URL = "api.github.com"
	API_PORT = 443
	CLIENT_ID = Gist::Config::CLIENT_ID
	CLIENT_SECRET = Gist::Config::CLIENT_SECRET
end
