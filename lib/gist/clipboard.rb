module Gist
    class Clipboard
        def Clipboard::copy(str)
            Clipboard.clear()
            Clipboard.copy(str)
        end
    end
end