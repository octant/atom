module Atom
  class Plugger
    def self.load_plugins(plugins)
      case plugins
      when nil
        return false
      when plugins.empty?
        return false
      else
        plugins.each do |plugin|
          require "#{Atom::PATH}/plugins/#{plugin}.rb"
        end
        return true
      end      
    end
    
    def self.run_pre(temp_file_path)
      if Atom::CONFIG['plugins']
        if load_plugins(Atom::CONFIG['plugins']['pre'])
          run(temp_file_path)
        end
      end
    end
    
    def self.run_post(out_file_path)
      if Atom::CONFIG['plugins']
        if load_plugins(Atom::CONFIG['plugins']['post'])
          run(out_file_path)
        end
      end
    end
    
    def self.run(file_path)
      text = File.read(file_path)
      
      Atom::Plugin.subclasses.each do |subclass|
        text = subclass.new(text)
      end
      
      Atom::write_file(file_path, text)
    end
  end
end