module Atom
  class Plugger
    def self.load_plugins(plugin_path, plugins)
      plugins.each do |plugin|
        require File.join("#{plugin_path}", "#{plugin}.rb")
      end
    end
    
    def self.run(plugins, file_path)
      text = File.read(file_path)
      
      plugins.each do |plugin|
        classname = plugin.split('_').map(&:capitalize).join
        text = Kernel.const_get(classname).new(text).to_s
      end
      
      Atom::write_file(file_path, text)
    end
  end
end