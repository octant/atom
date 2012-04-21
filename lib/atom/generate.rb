
module Atom
  class Generate
    def self.template(type, title)
      dest = self.destination("source", type)
      file_name = self.name(type, title)
      template = File.read("#{Atom::PATH}/templates/#{type}.textile")
      
      if File.exist?(File.join(dest, file_name))
        raise "File already exists"
      else
        $stdout.puts "create [File]: #{File.join(dest, file_name)}"
        File.open(File.join(dest, file_name), "w").write(
        Mustache.render(
          template, title: title, author: Atom::CONFIG[:author])
        )
      end
    end
    
    def self.temp_file(type, title)
      dest = self.destination("temp", type)
      file_name = self.name(type, title)
      
      File.open("#{Atom::PATH}/temp/#{file_name}", "w") do |file|
        file.puts Atom::sub_topics(Atom::get_src_file_by_title(title, 'maps'))
      end
      
      return "#{Atom::PATH}/temp/#{file_name}"
    end
    
    def self.html(file)
      out_file_name = "#{File.basename(file, ".textile").split('_')[1..-1].join('_')}.html"
      out_file_path = File.join(Atom::PATH, "output/html")
      out_file = File.join(out_file_path, out_file_name)
      
      doc = File.read(file)
      rc = RedCloth.new(doc)
      
      if File.exist? out_file
        $stdout.puts "overwrite [File]: output/html/#{out_file_name}"
      else
        $stdout.puts "create [File]: output/html/#{out_file_name}"
      end
      
      File.open(out_file, "w") do |file|
        file.puts rc.to_html
      end
      
    end
    
    # Helpers
    
    def self.name(type, title)
      "#{type.split('').first}_#{title.chomp.downcase.split.join('_')}.textile"
    end
    
    def self.destination(root, type)
      case type
      when 'concept', 'procedure'
        root = File.join(root, 'topics')
      when 'map'
        root = File.join(root, 'maps')
      end
      
      return root
    end
    
  end
end