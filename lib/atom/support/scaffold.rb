require 'fileutils'

module Atom
  class Scaffold
    def self.create(root_dir)
      dirs = [
        'source',
        ['source', 'atoms'],
        ['source', 'maps'],
        'config',
        'temp',
        'output',
        'templates'
      ]
      
      if mkdirs(root_dir, dirs)
        mk_dotatom(root_dir)
        mk_dotgitignore(root_dir)
        mk_atom(root_dir)
        mk_concept(root_dir)
        mk_procedure(root_dir)
        mk_map(root_dir)
      end
    end
    
    def self.mk_dotatom(root_dir)
      FileUtils.touch "#{root_dir}/.atom"
    end
    
    def self.mk_dotgitignore(root_dir)
      FileUtils.touch "#{root_dir}/.gitignore"
    end
    
    def self.mk_atom(root_dir)
      FileUtils.touch "#{root_dir}/config/atom.yml"
    end
    
    def self.mk_concept(root_dir)
      FileUtils.touch "#{root_dir}/templates/concept.textile"
    end
    
    def self.mk_procedure(root_dir)
      FileUtils.touch "#{root_dir}/templates/procedure.textile"
    end
    
    def self.mk_map(root_dir)
      FileUtils.touch "#{root_dir}/templates/map.textile"
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