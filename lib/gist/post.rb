module Gist
    class Post
        attr_accessor :source_files
        attr_accessor :authenticated_user
    
        def initialize(filenames, pub=false, description=nil, user=nil)
            @authenticated_user = user
            @public = pub
            if description then @description = description else @description = "" end
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
end