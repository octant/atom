module Atom
  class Generate
    def self.from_template(type, title)
      dest = type == 'map' ? "source/maps" : "source/topics"
      file_name = Atom::name(type, title)
      template = File.read("#{Atom::PATH}/templates/#{type}.textile")
      
      if File.exist?(File.join(dest, file_name))
        raise "File already exists"
      else
        $stdout.puts "create [File]: #{File.join(dest, file_name)}"

        Atom::write_file(
          File.join(dest, file_name),
          Mustache.render(
            template, :title => title, :author => Atom::CONFIG[:author]
          )
        )
      end
    end
    
    def self.temp_file(type, title)
      file_name = Atom::name(type, title)
      
      Atom::write_file(
        "#{Atom::PATH}/temp/#{file_name}",
        Atom::sub_topics(Atom::get_src_file_by_title(title, 'maps'))
      )
      
      return "#{Atom::PATH}/temp/#{file_name}"
    end
    
    def self.html(file)
      out_file_name = "#{File.basename(file, ".textile").split('_')[1..-1].join('_')}.html"
      out_file_path = File.join(Atom::PATH, "output/html")
      out_file = File.join(out_file_path, out_file_name)
      template = File.read(File.join(Atom::PATH, "templates/default.html"))
      
      doc = File.read(file)
      rc = RedCloth.new(doc)
      
      if File.exist? out_file
        $stdout.puts "overwrite [File]: output/html/#{out_file_name}"
      else
        $stdout.puts "create [File]: output/html/#{out_file_name}"
      end
      
      Atom::write_file(
        out_file,
        Mustache.render(
          template, :body => rc.to_html,
          :title => File.basename(file)
        )
      )
      
      return out_file
    end
  end
end