Feature: User Registration

    Scenario: User can sign up
        Given the sign up page is open
        When the user fills in the form with valid credentials
        And they submit the form 
        Then they should see a success message
