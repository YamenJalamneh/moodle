@mod @mod_forum
Feature: The forum search allows users to perform advanced searches for forum posts
  In order to perform an advanced search for a forum post
  As a teacher
  I can use the search feature

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email | idnumber |
      | teacher1 | Teacher | ONE | teacher1@example.com | T1 |
      | teacher2 | Teacher | TWO | teacher2@example.com | T1 |
      | student1 | Student | 1 | student1@example.com | S1 |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1 | 0 |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | teacher2 | C1 | editingteacher |
      | student1 | C1 | student |
    And the following "tags" exist:
      | name         | isstandard  |
      | SearchedTag  | 1           |
    And the following "blocks" exist:
      | blockname  | contextlevel | reference | pagetypepattern | defaultregion |
      | news_items | Course       | C1        | course-view-*   | side-pre      |
    And I am on the "Course 1" "course editing" page logged in as teacher1
    And I expand all fieldsets
    And I set the field "id_newsitems" to "1"
    And I press "Save and display"
    And I add a new topic to "Announcements" forum with:
      | Subject | My subject |
      | Message | My message |
    And I am on "Course 1" course homepage
    And I add a new topic to "Announcements" forum with:
      | Subject | Your subjective|
      | Message | Your long message |

  Scenario: Perform an advanced search using any term
    Given I am on the "Announcements" "forum activity" page logged in as student1
    And I press "Search forums"
    And I should see "Advanced search"
    And I set the field "words" to "subject"
    When I press "Search forums"
    Then I should see "My subject"
    And I should see "Your subjective"

  Scenario: Perform an advanced search avoiding words
    Given I am on the "Announcements" "forum activity" page logged in as student1
    And I press "Search forums"
    And I should see "Advanced search"
    And I set the field "words" to "My"
    And I set the field "notwords" to "subjective"
    When I press "Search forums"
    Then I should see "My subject"
    And I should not see "Your subjective"

  Scenario: Perform an advanced search using whole words
    Given database family used is one of the following:
      | mysql    |
      | postgres |
    And I am on the "Announcements" "forum activity" page logged in as student1
    And I press "Search forums"
    And I should see "Advanced search"
    And I set the field "fullwords" to "subject"
    When I press "Search forums"
    Then I should see "My subject"
    And I should not see "Your subjective"

  Scenario: Perform an advanced search matching the subject
    Given I am on the "Announcements" "forum activity" page logged in as student1
    And I press "Search forums"
    And I should see "Advanced search"
    And I set the field "subject" to "subjective"
    When I press "Search forums"
    Then I should not see "My message"
    And I should see "Your subjective"

  Scenario: Perform an advanced search matching the author
    Given I log in as "teacher2"
    And I am on "Course 1" course homepage
    And I add a new topic to "Announcements" forum with:
      | Subject | My Subjects |
      | Message | My message |
    And I log out
    When I am on the "Announcements" "forum activity" page logged in as student1
    And I press "Search forums"
    And I should see "Advanced search"
    And I set the field "user" to "TWO"
    And I press "Search forums"
    Then I should see "Teacher TWO"
    And I should not see "Teacher ONE"

  Scenario: Perform an advanced search with multiple words
    Given I am on the "Announcements" "forum activity" page logged in as student1
    And I press "Search forums"
    And I should see "Advanced search"
    And I set the field "subject" to "your subjective"
    When I press "Search forums"
    Then I should not see "My message"
    And I should see "Your subjective"

  @javascript
  Scenario: Perform an advanced search using tags
    Given I am on the "Announcements" "forum activity" page logged in as teacher1
    And I follow "My subject"
    And I follow "Edit"
    And I set the following fields to these values:
        | Tags    | SearchedTag |
    And I press "Save changes"
    And I log out
    And I am on the "Announcements" "forum activity" page logged in as student1
    And I press "Search forums"
    And I should see "Advanced search"
    And I set the field "Is tagged with" to "SearchedTag"
    When I press "Search forums"
    Then I should see "My subject"
    And I should not see "Your subjective"

  @javascript
  Scenario: Perform an advanced search on starred discussions without text
    Given I am on the "Announcements" "forum activity" page logged in as student1
    And I click on "Star this discussion" "link" in the "Your subjective" "table_row"
    And I press "Search forums"
    And I should see "Advanced search"
    And I set the field "starredonly" to "1"
    When I press "Search forums"
    Then I should not see "My message"
    And I should see "Your subjective"

  @javascript
  Scenario: Perform an advanced search on starred discussions with text
    Given I am on the "Announcements" "forum activity" page logged in as student1
    And I click on "Star this discussion" "link" in the "Your subjective" "table_row"
    And I press "Search forums"
    And I should see "Advanced search"
    And I set the field "words" to "message"
    And I set the field "starredonly" to "1"
    When I press "Search forums"
    Then I should not see "My message"
    And I should see "Your subjective"
