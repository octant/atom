Feature: We can create a new atom project
	As an administrator responsible for keeping documentation up-to-date
	I want to use atom to manage my documentation
	
	Scenario: Create a new atom project
		When I successfully run `atom init docs`
		Then the following directories should exist:
			| docs |
			| docs/config |
			| docs/output |
			| docs/output/html |
			| docs/source |
			| docs/source/topics |
			| docs/source/maps |
			| docs/temp |
			| docs/templates |
		And the following files should exist:
			| docs/.atom |
			| docs/.gitignore |
			| docs/config/atom.yml |
			| docs/templates/concept.textile |
			| docs/templates/procedure.textile |
			| docs/templates/map.textile |
		And the stdout should contain:
			"""
			create  [Dir]: docs/source
			create  [Dir]: docs/source/topics
			create  [Dir]: docs/source/maps
			create  [Dir]: docs/config
			create  [Dir]: docs/temp
			create  [Dir]: docs/output
			create  [Dir]: docs/output/html
			create  [Dir]: docs/templates
			create [File]: docs/.atom
			create [File]: docs/.gitignore
			create [File]: docs/config/atom.yml
			create [File]: docs/templates/concept.textile
			create [File]: docs/templates/procedure.textile
			create [File]: docs/templates/map.textile
			"""
	
	Scenario: Run the `atom init` command without providing a project name
		When I run `atom init`
		Then the exit status should not be 0
		And the stderr should contain:
			"""
			You must provide a project name
			"""
	
	Scenario: Run the `atom init` command with more than 1 argument
		When I successfully run `atom init docs drp contracts`
		Then the following directories should exist:
			| docs |
			| drp |
			| contracts |
	
	Scenario: Attempt to create a new atom project with the same name as an existing directory
		Given a directory named "docs"
		When I run `atom init docs`
		Then the exit status should not be 0
		And the stderr should contain:
			"""
			'docs' already exists
			"""
	
	Scenario: Attempt to create a new atom project in an atom directory
		Given an empty file named ".atom"
		When I run `atom init docs`
		Then the exit status should not be 0
		And the stderr should contain:
			"""
			This appears to be an atom directory
			"""