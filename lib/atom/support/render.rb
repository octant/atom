
module Atom
  class Render
    def self.template(type, title)
      dest = "source"
      name = "#{type.split('').first}_#{title.chomp.downcase.split.join('_')}.textile"
      template = File.read("#{Atom::PATH}/templates/#{type}.textile")
      
      case type
      when 'concept', 'procedure'
        dest = File.join(dest, 'topics')
      when 'map'
        dest = File.join(dest, 'maps')
      end
      
      if File.exist?(File.join(dest, name))
        raise "File already exists"
      else
        $stdout.puts "create [File]: #{File.join(dest, name)}"
        File.open(File.join(dest, name), "w").write(
        Mustache.render(
          template, title: title, author: Atom::CONFIG[:author])
        )
      end
    end
  end
end