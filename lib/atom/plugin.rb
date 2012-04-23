module Atom
  class Plugin
    def self.subclasses
      @subclasses ||= []
    end
    
    def self.inherited(base)
      subclasses << base
    end
    
    def initialize(content)
      @content = run(content)
    end
    
    def to_s
      @content
    end
  end
end