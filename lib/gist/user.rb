require 'pry'

module Gist
  # Class to hold user information
  class User
    attr_accessor :username
    attr_accessor :password
    attr_accessor :access_token # Personal access token

    # Create the GistUser instance
    def initialize(username = nil, password = nil, netrc = nil)
      @username ||= username
      @password ||= password
      @netrc ||= netrc
      @http = Net::HTTP.new(Gist::API_URL, Gist::API_PORT)
      @http.use_ssl = true
      @access_token = load_token if saved?
    end

    # Authentication method, will set the authentication token for the user
    def authenticate
      # If we already have authenticated, don't let it happen again
      return unless @access_token.nil?
      # If not, let's authenticate
      @http.start do |http|
        response = http.request(auth_obj)
        json_response = JSON.parse(response.body)
        @access_token = json_response['token']
      end
      # Then save
      save
      populate_methods(user_info)
    end

    private def user_info
      headers = { 'Authorization' => "token #{access_token}" }
      response = @http.get('/user', headers)
      JSON.parse(response.body)
    end

    private def populate_methods(response)
      response.each do |k, v|
        define_singleton_method(k) { v }
      end
    end

    private def saved?
      if @netrc.nil?
        File.exist?(Gist::ACCESS_TOKEN_PATH)
      else
        netrc = Netrc.read
        _username, token = netrc['api.github.com']
        !token.nil?
      end
    end

    private def save
      if @netrc.nil?
        unless Dir.exist?(File.dirname(Gist::ACCESS_TOKEN_PATH))
          Dir.mkdir(File.dirname(Gist::ACCESS_TOKEN_PATH))
        end
        token_file = File.new(Gist::ACCESS_TOKEN_PATH, 'w+')
        token_file << @access_token
        token_file.close
      else
        netrc = Netrc.read
        netrc['api.github.com'] = @username, @access_token
        netrc.save
      end
    end

    private def load_token
      if @netrc.nil?
        File.readlines(Gist::ACCESS_TOKEN_PATH).first
      else
        netrc = Netrc.read
        _username, token = netrc['api.github.com']
        token
      end
    end

    private def auth_obj
      req = Net::HTTP::Post.new('/authorizations')
      req.basic_auth(@username, @password)
      req['Content-Type'] = 'application/json'
      req.body = {
        scopes: ['gist'], # Only need Gist scope
        note: "Gist access for GistRB client on #{Socket.gethostname}",
        note_url: 'https://github.com/cameronbroe/gistrb'
      }.to_json
      req
    end
  end
end
