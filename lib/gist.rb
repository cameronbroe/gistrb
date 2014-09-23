require 'net/http'
require 'net/https'
require 'highline/import'
require 'json'
require_relative './config.rb'

module Gist
	# Module level constants
	API_URL = "api.github.com"
	API_PORT = 443
	CLIENT_ID = Gist::Config::CLIENT_ID
	CLIENT_SECRET = Gist::Config::CLIENT_SECRET

	class User
		attr_accessor :username 
		attr_accessor :password
		attr_accessor :authentication_token # OAuth 2 token

		# Create the GistUser instance
		def initialize(username=nil, password=nil)
			@username = username
			@password = password
			@http = Net::HTTP.new(Gist::API_URL, Gist::API_PORT)
			@http.use_ssl = true
			@http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		end

		# Authentication method, will set the authentication token for the user
		def authenticate
			# Check to see if we already have an authentication token for current user
			# If it is, get it
			if saved? then
				@authentication_token = load_token
				#puts @authentication_token
				populate_methods(get_user_info)
				return
			end
			# If not, go on and authenticate
			return if defined?(@authentication_token) # If we already have authenticated, don't let it happen again
			@http.start() do |http|
				req = Net::HTTP::Post.new('/authorizations')
				req.basic_auth(@username, @password)
				req_hash = Hash.new
				req_hash[:client_secret] = Gist::CLIENT_SECRET
				req_hash[:client_id] = Gist::CLIENT_ID
				req_hash[:scopes] = ["gist"] # Only need Gist scope
				req_hash[:note] = "Gist access"
				req.body = req_hash.to_json
				response = http.request(req)
				json_response = JSON.parse(response.body)
				@authentication_token = json_response["token"]
			end
			# Then save
			save
			populate_methods(get_user_info)
		end

		private
			def get_user_info
				@http.start() do |http|
					req = Net::HTTP::Get.new('/user')
					req["Authorization"] = "token #{authentication_token}"
					response = http.request(req)
					JSON.parse(response.body)
				end
			end

			def populate_methods(response)
				response.each do |k, v|
					define_singleton_method(k) { v }
				end
			end

			def saved?
				File.exists?("#{Dir.home}/.gistruby/oauth_token")
			end

			def save
				unless Dir.exists?("#{Dir.home}/.gistruby")
					Dir.mkdir("#{Dir.home}/.gistruby")
				end
				token_file = File.new("#{Dir.home}/.gistruby/oauth_token", "w+")
				token_file << @authentication_token
				token_file.close
			end

			def load_token
				File.readlines("#{Dir.home}/.gistruby/oauth_token").first
			end
	end

	class Post
		attr_accessor :source_files
		attr_accessor :authenticated_user

		def initialize(filenames, pub=false, description=nil, user=nil)
			@authenticated_user = user
			@public = pub
			@description = description
			@source_files = Hash.new
			filenames.each do |filename|
				@source_files[File.basename(filename)] = {
					"content" => load_code(filename) 
				}
			end
			@http = Net::HTTP.new(Gist::API_URL, Gist::API_PORT)
			@http.use_ssl = true
			@http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		end

		def submit
			@http.start() do |http|
				req = Net::HTTP::Post.new('/gists')
				req["Authorization"] = "token #{@authenticated_user.authentication_token}" if @authenticated_user != nil
				req.body = {
					"files" => @source_files,
					"public" => @public,
					"description" => @description
				}.to_json
				response = http.request(req)
				response_json = JSON.parse(response.body)
				gist_url = response_json["html_url"]
			end
		end

		private
			def load_code(filename)
				file = File.open(filename)
				file_str = ""
				file.each do |line|
					file_str << line
				end
				file_str
			end
	end

	class Helpers
		def Helpers::get_password(prompt="Password: ")
			ask(prompt) { |q| q.echo = false }
		end
	end
end