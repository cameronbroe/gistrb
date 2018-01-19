module Gist
  # Helper methods for getting input
  class Helpers
    # Method to wrap a highline call to hide a passworded input
    def self.get_password(prompt = 'Password: ')
      ask(prompt) { |q| q.echo = false }
    end
  end
end
