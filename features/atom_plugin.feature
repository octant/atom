Feature: we can allow users to modify the build process with plugins
	In order to allow integration with other systems and greater control over output
	As an administrator responsible for keeping documentation up-to-date
	I want to be able to use plugins to control the build process
	
	Scenario: hook in to build process before html generation
		When I successfully run `atom init docs`
		And I cd to "docs"
		And I successfully run `atom new -m 'Map Titled Text'`
		And I append to "config/atom.yml" with:
			"""
			
			plugins: { pre: [tilted] }
			"""
		And a file named "plugins/tilted.rb" with:
			"""
			class Tilted < Atom::Plugin
			  def run(text)
			    text.gsub(/Titled/, "Tilted")
			  end
			end
			"""
		And I successfully run `atom build 'Map Titled Text'`
		Then the file "temp/m_map_titled_text.textile" should contain "Tilted"
	
	Scenario: hook in to build process after html generation
		When I successfully run `atom init docs`
		And I cd to "docs"
		And I successfully run `atom new -m 'Map Titled Text'`
		And I append to "config/atom.yml" with:
			"""
			
			plugins: { post: [mad] }
			"""
		And a file named "plugins/mad.rb" with:
			"""
			class Mad < Atom::Plugin
			  def run(text)
			    text.gsub(/Map/, "Mad")
			  end
			end
			"""
		And I successfully run `atom build 'Map Titled Text'`
		Then the file "output/html/map_titled_text.html" should contain "Mad"
		