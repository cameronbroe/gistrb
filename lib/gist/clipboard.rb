module Gist
  # Helper class for clipboard functions
  class Clipboard
    # Wraps clipboard functionality
    def self.copy(str)
      Clipboard.clear
      Clipboard.copy(str)
    end
  end
end
