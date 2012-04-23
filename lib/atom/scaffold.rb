module Atom
  class Scaffold
    def self.create(root_dir)
      dirs = [
        'source',
        ['source', 'topics'],
        ['source', 'maps'],
        'config',
        'temp',
        'output',
        ['output', 'html'],
        'templates'
      ]
      
      if mkdirs(root_dir, dirs)
        mk_dotatom(root_dir)
        mk_dotgitignore(root_dir)
        mk_atom(root_dir)
        mk_concept(root_dir)
        mk_procedure(root_dir)
        mk_map(root_dir)
        mk_html_skeleton(root_dir)
      end
    end
    
    def self.mk_dotatom(root_dir)
      $stdout.puts "create [File]: #{root_dir}/.atom"
      FileUtils.touch "#{root_dir}/.atom"
    end
    
    def self.mk_dotgitignore(root_dir)
      $stdout.puts "create [File]: #{root_dir}/.gitignore"
      File.open("#{root_dir}/.gitignore", "w") do |file|
        file.puts <<EOS
config/
output/
temp/
EOS
      end
    end
    
    def self.mk_atom(root_dir)
      $stdout.puts "create [File]: #{root_dir}/config/atom.yml"
      File.open("#{root_dir}/config/atom.yml", "w") do |file|
        file.puts <<EOS
markup: textile
EOS
      end
    end
    
    def self.mk_concept(root_dir)
      $stdout.puts "create [File]: #{root_dir}/templates/concept.textile"
      File.open("#{root_dir}/templates/concept.textile", "w") do |file|
        file.puts <<EOS
---
author: {{author}}
class: concept
---

h1(topic-title). {{title}}

EOS
      end
    end
    
    def self.mk_procedure(root_dir)
      $stdout.puts "create [File]: #{root_dir}/templates/procedure.textile"
      File.open("#{root_dir}/templates/procedure.textile", "w") do |file|
        file.puts <<EOS
---
author: {{author}}
class: procedure
---

h1(topic-title). {{title}}

p(preparation). Before you begin

h2. Procedure

# Step 1

p(result). Result of procedure

EOS
      end
    end
    
    def self.mk_map(root_dir)
      $stdout.puts "create [File]: #{root_dir}/templates/map.textile"
      File.open("#{root_dir}/templates/map.textile", "w") do |file|
        file.puts <<EOS
---
author: {{author}}
class: map
---

h1(map-title). {{title}}

To include topics in this document, begin a line with @=@ followed by a space and the title of the topic. Like so:

bc. = Title of My Topic

EOS
      end
    end
    
    def self.mk_html_skeleton(root_dir)
      $stdout.puts "create [File]: #{root_dir}/templates/default.html"
      File.open("#{root_dir}/templates/default.html", "w") do |file|
        file.puts <<EOS
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>{{title}}</title>
</head>
  <body>
  {{{body}}}
  </body>
</html>
EOS
      end
    end
    
    def self.mkdirs(root_dir, dirs)
      if File.exist? root_dir
        raise "'#{root_dir}' already exists"
        return false
      end
      
      FileUtils.mkdir root_dir
      
      dirs.each do |dir|
        $stdout.puts "create  [Dir]: #{File.join(root_dir, dir)}"
        FileUtils.mkdir "#{File.join(root_dir, dir)}"
      end
    end
  end
end