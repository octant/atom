module Atom
  def self.load_config
    const_set(:PATH, Dir.pwd)
    const_set(:CONFIG, YAML.load_file("#{PATH}/config/atom.yml"))

    unless CONFIG[:author]
      begin
        CONFIG[:author] = `git config --get user.name`.chomp
      rescue
        CONFIG[:author] = 'unknown'
      end
    end
  end
  
  def self.read_yaml(content)
    begin
      if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        content = $'
        data = YAML.load($1)
      end
    rescue => e
      puts "YAML Exception: #{e.message}"
    end

    data ||= {}
    return [data, content]
  end
  
  def self.sub_topics(file)
    map_data, content = Atom::read_yaml(File.read(file))
    new_file = ''

    content.split("\n").each do |line|
      if line.match(/^=/)
        depth, title = line.match(/^=(\d)? (.*)/)[1..2]
        depth ||= 0
        data, content = Atom::read_yaml(
          File.read(
            Dir.glob("source/topics/?_#{title.downcase.split.join('_')}.textile").first # Test if it's a file
            ).gsub(/^h(\d)(.*)/) { "h#{($1.to_i + depth.to_i).to_s}#{$2}" }
        )
        
        new_file += "<section class=\"#{data['class']}\" author=\"#{data['author']}\">\n"
        new_file += "\n#{content}\n"
        new_file += "</section>"
        new_file += "\n"
      else
        new_file += "#{line}\n"
      end
    end
      
    return new_file
  end
  
  def self.get_src_file_by_title(title, src_dir)
    # TODO abastract file extension to accomodate markup choice
    file_title = title.downcase.split.join('_')
    result = Dir.glob("#{Atom::PATH}/source/#{src_dir}/*#{file_title}.textile")
    if result.size == 1
      result.first
    elsif result.size == 0
      raise ArgumentError, "Title not found"
    else 
      raise ArgumentError, "Ambiguous title"
    end
  end
  
  # Ensure files are written in a consistant manner
  def self.write_file(path, content)
    file = File.open(path, "w")
    file.write(content)
    file.flush
    file.close
  end
end