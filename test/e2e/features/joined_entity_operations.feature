Feature: Posting new entities with foreign keys

  Background:
    Given I have the example "bookshop" application

  Scenario: Putting a join entity
    Given I put an example "book" entity
      And I put an example "genre" entity
     When I "put" a "book_genre" join entity
     Then I can see that genre in the response from "book/{id}/genres"

  Scenario: Getting an eager relationship at the end of an API path
    Given I put an example "book" entity
      And I put an example "author" entity
      And I put a book entity with a relationship to that author
     When I get that book entity
     Then I can see a hydrated book in the response from "book/{id}/author"

  Scenario: Putting a join entity where the join does not exist
    Given I put an incorrect "book_genre" join entity
     Then I get http status "400"

  Scenario: Getting a non-lazy joined entity
    Given I put an example "author" entity
      And I put a book entity with a relationship to that author
     When I get that book entity
     Then I can see that author in the response

  Scenario: PATCHing a relationship
    Given I put an example "book" entity
      And I put an example "author" entity
     When I patch that "book" entity with that "author" id
     Then I can see that book in the response from "author/{id}/books"

  Scenario: PATCHing a property
    Given I put an example "book" entity
      And I put an example "author" entity
      And I patch that "book" entity with that "author" id
     When I patch that "book" entity to set "name" to "dave dave dave: the dave story"
     Then I can see that "book" has "name" set to "dave dave dave: the dave story"

  Scenario: POSTing a join entity
    Given I put an example "book" entity
      And I put an example "genre" entity
     When I "post" a "book_genre" join entity
     Then I can see that genre in the response from "book/{id}/genres"

