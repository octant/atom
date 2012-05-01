module Atom
  def self.load_config
    const_set(:PATH, Dir.pwd)
    const_set(:CONFIG, YAML.load_file("#{PATH}/config/atom.yml"))
    const_set(:PRE_PLUGINS, CONFIG['plugins']['pre'])
    const_set(:POST_PLUGINS, CONFIG['plugins']['post'])
    const_set(:PLUGINS, PRE_PLUGINS | POST_PLUGINS)
    
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
      $stderr.puts "YAML Exception: #{e.message}"
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
            Atom::get_src_file_by_title(title, 'topics')
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
    file_title = title.downcase.split.join('_')
    result = Dir.glob("#{Atom::PATH}/source/#{src_dir}/?_#{file_title}.*")
    if result.size == 1
      result.first
    elsif result.size == 0
      raise "Title '#{title}' not found"
    else 
      raise "Ambiguous title '#{title}'"
    end
  end
  
  def self.name(type, title)
    # TODO abastract file extension to accomodate markup choice
    "#{type.split('').first}_#{title.chomp.downcase.split.join('_')}.textile"
  end
  
  # Ensure files are written in a consistant manner
  def self.write_file(path, content)
    file = File.open(path, "w")
    file.write(content)
    file.flush
    file.close
  end
end