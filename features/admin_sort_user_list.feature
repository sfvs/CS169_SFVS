Feature: sort users by their information
 
  As an admin
  So that I can view my attendees
  I want to be able to see the users list
  sorted by company name, contact person, or by e-mail.

Background: users have been added to database
  
  Given the following users exist: 
  | email            | password         | company_name | contact_person | admin   |
  | user1@gmail.com  | bear12345        | Apple        | Oski           | false   |
  | user2@gmail.com  | bear12345        | Corn         | Cal Bear       | false   |
  | admin@gmail.com  | admin123         |              |                | true    |
  | dog@gmail.com    | dog12345         | Cabbage      | Husky          | false   |
  | cat@gmail.com    | cat12345         | Brocoli      | Persian        | false   |

  And I am logged into the admin page as "admin"
  Given I am on the admin profile page
  When I follow "Users List"

Scenario: sort users by e-mail
  When I follow "E-mail"
  Then users should be sorted by "email":
  | email            | password         | company_name | contact_person | admin   |
  | cat@gmail.com    | cat12345         | Brocoli      | Persian        | false   |
  | dog@gmail.com    | dog12345         | Cabbage      | Husky          | false   |
  | user1@gmail.com  | bear12345        | Apple        | Oski           | false   |
  | user2@gmail.com  | bear12345        | Corn         | Cal Bear       | false   |

Scenario: sort users by company name
  When I follow "Company Name"
  Then users should be sorted by "company_name":
  | email            | password         | company_name | contact_person | admin   |
  | user1@gmail.com  | bear12345        | Apple        | Oski           | false   |
  | cat@gmail.com    | cat12345         | Brocoli      | Persian        | false   |
  | dog@gmail.com    | dog12345         | Cabbage      | Husky          | false   |
  | user2@gmail.com  | bear12345        | Corn         | Cal Bear       | false   |

Scenario: sort users by contact person
  When I follow "Contact Person"
  Then users should be sorted by "contact_person":
  | email            | password         | company_name | contact_person | admin   |
  | user2@gmail.com  | bear12345        | Corn         | Cal Bear       | false   |
  | dog@gmail.com    | dog12345         | Cabbage      | Husky          | false   |
  | user1@gmail.com  | bear12345        | Apple        | Oski           | false   |
  | cat@gmail.com    | cat12345         | Brocoli      | Persian        | false   |