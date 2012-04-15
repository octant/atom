Feature: We can generate atoms from templates
	In order to save time
	As an administrator responsible for keeping documentation up-to-date
	I want to be able generate atoms from templates
	
	Scenario: Generate a new procedure
		When I successfully run `atom init docs`
		And I cd to "docs"
		And I successfully run `atom new -p 'Topic Title Text'`
		Then the stdout should contain:
			"""
			create [File]: source/topics/p_topic_title_text.textile
			"""
		And a file named "source/topics/p_topic_title_text.textile" should exist
		And the file "source/topics/p_topic_title_text.textile" should contain "Topic Title Text"
	
	Scenario: Generate a new concept with the [t, type] flag
		When I successfully run `atom init docs`
		And I cd to "docs"
		And I successfully run `atom new -c 'Atom Title Text'`
		Then the stdout should contain:
			"""
			create [File]: source/topics/c_atom_title_text.textile
			"""
		And a file named "source/topics/c_atom_title_text.textile" should exist
		And the file "source/topics/c_atom_title_text.textile" should contain "Atom Title Text"

	Scenario: Generate a new molecule with the [t, type] flag
		When I successfully run `atom init docs`
		And I cd to "docs"
		And I successfully run `atom new -m 'Atom Title Text'`
		Then the stdout should contain:
			"""
			create [File]: source/maps/m_atom_title_text.textile
			"""
		And a file named "source/maps/m_atom_title_text.textile" should exist
		And the file "source/maps/m_atom_title_text.textile" should contain "Atom Title Text"
			
	Scenario: Attempt to generate an existing atom
		When I successfully run `atom init docs`
		And I cd to "docs"
		Given an empty file named "source/topics/p_atom_title_text.textile"
		And I run `atom new -p 'Atom Title Text'`
		Then the exit status should not be 0
		And the stderr should contain:
			"""
			File already exists
			"""

	Scenario: Attempt to generate a new procedure while not in an atom directory
		When I run `atom new 'Atom Title Text'`
		Then the exit status should not be 0
		And the stderr should contain:
			"""
			This command needs to run in an atom directory
			"""