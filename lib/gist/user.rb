module Gist
  # Class to hold user information
  class User
    attr_accessor :username
    attr_accessor :password
    attr_accessor :acess_token # Personal access token

    # Create the GistUser instance
    def initialize(username = nil, password = nil)
      @username = username
      @password = password
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
        @authentication_token = json_response['token']
      end
      # Then save
      save
      populate_methods(get_user_info)
    end

    private def user_info
      headers = { 'Authorization' => "token #{authentication_token}" }
      response = @http.get('/user', headers)
      JSON.parse(response.body)
    end

    private def populate_methods(response)
      response.each do |k, v|
        define_singleton_method(k) { v }
      end
    end

    private def saved?
      File.exist?(Gist::ACCESS_TOKEN_PATH)
    end

    private def save
      unless Dir.exist?(File.dirname(Gist::ACCESS_TOKEN_PATH))
        Dir.mkdir(File.dirname(Gist::ACCESS_TOKEN_PATH))
      end
      token_file = File.new(Gist::ACCESS_TOKEN_PATH, '0600')
      token_file << @authentication_token
      token_file.close
    end

    private def load_token
      File.readlines(Gist::ACCESS_TOKEN_PATH).first
    end

    private def auth_obj
      req = Net::HTTP::Post.new('/authorizations')
      req.basic_auth(@username, @password)
      req['Content-Type'] = 'application/json'
      req.body = {
        scopes: ['gist'], # Only need Gist scope
        note: 'Gist access for GistRB client',
        note_url: 'https://github.com/cameronbroe/gistrb'
      }.to_json
      req
    end
  end
end
