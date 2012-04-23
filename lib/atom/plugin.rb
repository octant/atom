module Atom
  class Plugin
    def initialize(content)
      @content = run(content)
    end
    
    def to_s
      @content
    end
  end
end