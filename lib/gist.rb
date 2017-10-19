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
  API_URL = 'api.github.com'.freeze
  API_PORT = 443

  ACCESS_TOKEN_PATH = "#{Dir.home}/.gistrb/access_token".freeze
end
