Feature: we can generate html documents from our textile documents
	In order to share my documentation with others
	As an administrator responsible for keeping documentation up-to-date
	I want to generate html from my textile documents
	
	Scenario: generate html from maps
		When I successfully run `atom init docs`
		And I cd to "docs"
		And I successfully run `atom new -m 'Map Title Text'`
		And a file named "source/topics/c_topic_title.textile" with:
			"""
			h1(title). Topic Title
			
			"""
		And I append to "source/maps/m_map_title_text.textile" with:
			"""
			
			=1 Topic Title
			"""
		And I successfully run `atom build 'Map Title Text'`
		Then the stdout should contain:
			"""
			create [File]: output/html/map_title_text.html
			"""
		And the following files should exist:
			| output/html/map_title_text.html |
			| temp/m_map_title_text.textile |
		And the file "temp/m_map_title_text.textile" should contain "h2(title). Topic Title"
		And the file "output/html/map_title_text.html" should contain ">Topic Title</h2>"
		
	Scenario: html generation will overwrite existing files
		When I successfully run `atom init docs`
		And I cd to "docs"
		And I successfully run `atom new -m 'Map Title Text Overwrite'`
		And I successfully run `atom build 'Map Title Text Overwrite'`
		Then the stdout should contain:
			"""
			create [File]: output/html/map_title_text_overwrite.html
			"""
		And I append to "source/maps/m_map_title_text_overwrite.textile" with:
			"""
			
			h1. Unique Title
			"""
		And I successfully run `atom build 'Map Title Text Overwrite'`
		Then the stdout should contain:
			"""
			overwrite [File]: output/html/map_title_text_overwrite.html
			"""
		And the file "output/html/map_title_text_overwrite.html" should contain "<h1>Unique Title</h1>"
		
	Scenario: use an html skeleton
		When I successfully run `atom init docs`
		And I cd to "docs"
		And I successfully run `atom new -m 'Map Title Text Overwrite'`
		And I successfully run `atom build 'Map Title Text Overwrite'`
		Then the file "output/html/map_title_text_overwrite.html" should contain "<!DOCTYPE html>"