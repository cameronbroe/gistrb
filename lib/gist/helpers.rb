module Gist
    class Helpers
        def Helpers::get_password(prompt="Password: ")
            ask(prompt) { |q| q.echo = false }
        end
    end
end