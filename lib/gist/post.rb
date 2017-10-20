module Gist
  # Class that controls a posted Gist
  class Post
    attr_accessor :source_files
    attr_accessor :user

    def initialize(filenames, pub = false, description = nil, user = nil)
      @user ||= user
      @public ||= pub
      @description ||= description ? description : ''
      @source_files ||= {}
      populate_source_files(filenames)
      @http = Net::HTTP.new(Gist::API_URL, Gist::API_PORT)
      @http.use_ssl = true
    end

    def submit
      body = {
        'files' => @source_files,
        'public' => @public,
        'description' => @description
      }.to_json
      headers ||= {}
      unless @user.nil?
        headers['Authorization'] = "token #{@user.access_token}"
      end
      response = @http.post('/gists', body, headers)
      JSON.parse(response.body)['html_url']
    end

    private

    def load_code(filename)
      file = File.open(filename)
      file_str = ''
      file.each do |line|
        file_str << line
      end
      file_str
    end

    private def populate_source_files(filenames)
      filenames.each do |filename|
        @source_files[File.basename(filename)] = {
          'content' => load_code(filename)
        }
      end
    end
  end
end
