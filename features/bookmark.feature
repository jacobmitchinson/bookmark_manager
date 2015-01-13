Feature: As a time pressed computer user
  So that I can quickly find websites I recently bookmarked
  I would like to see a reverse chronological list of links on the site homepage.

	Scenario: Show a list of links from the database
    Given I am on the homepage
    And I log in
    Then I should see a list of links

	Scenario: I want to add new links
    Given I am on the homepage
    And I log in
    When I add a new link
    Then I should see "link successfully added"

  Scenario: I want to add tags to the links
    Given I am on the homepage
    And I log in
    When I add a new link
    And I tag that link with "cool stuff"
    Then I should see "link tagged"
			  

