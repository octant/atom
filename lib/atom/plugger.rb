module Atom
  class Plugger
    def self.load_plugins(plugin_path, plugins)
      plugins.each do |plugin|
        require File.join("#{plugin_path}", "#{plugin}.rb")
      end
    end
    
    def self.run(file_path, plugins)
      text = File.read(file_path)
      
      plugins.each do |classname|
        text = Kernel.const_get(classname).new(text).to_s
      end
      
      Atom::write_file(file_path, text)
    end
  end
end