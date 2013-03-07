Feature: Merge Articles
  As an admin
  In order to reorganise duplicted articles
  I want to merge articles

  Background: Set-up blog, users, articles and comments

    Given the blog is set up

    Given the following users exist:
        | profile_id | login  | name  | password | email           | state  |
        | 2          | user_1 | User1 | 1234567  | foo@example.com | active |
        | 3          | user_2 | User2 | 1234567  | bar@example.com | active |

    Given the following articles exist:
        | id | title    | author | user_id | body     | allow_comments | published | published_at        | state     | type    |
        | 3  | Article1 | user_1 | 2       | Content1 | true           | true      | 2013-02-10 20:30:00 | published | Article |
        | 4  | Article2 | user_2 | 3       | Content2 | true           | true      | 2013-02-11 21:00:00 | published | Article |

    Given the following comments exist:
        | id | type    | author | body      | article_id | user_id | created_at          |
        | 1  | Comment | user_1 | Comment1A | 3          | 2       | 2013-02-12 10:31:00 |
        | 2  | Comment | user_2 | Comment1B | 3          | 3       | 2013-02-12 10:32:00 |
        | 3  | Comment | user_1 | Comment2A | 4          | 2       | 2013-02-12 10:33:00 |
        | 4  | Comment | user_2 | Comment2B | 4          | 3       | 2013-02-12 10:34:00 |

  Scenario: Admin users have access to the merge articles functionality
    Given I am logged in as an admin user
    And I am on the Edit page for Article with id 3
    Then I should see "Merge Articles"

  Scenario: Non-admin users do not have access to the merge articles functionality
    Given I am logged in as a non-admin user
    And I am on the Edit page for Article with id 3
    Then I should not see "Merge Articles"

  Scenario: Admin user successfully merges articles
    Given I am logged in as an admin user
    When I merge two articles
    Then there should be a merged article
    And the merged article contains body text of both original source articles
    And the merged article has same author as either of the original source articles
    And the merged article has carried across comments from both original source articles

  Scenario: Duplicate article has beeen deleted
    Then the duplicate article should be deleted


