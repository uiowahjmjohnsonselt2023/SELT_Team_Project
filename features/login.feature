Feature: User Authentication

    Scenario: User can log in 
        Given a registered user
        When the user logs in with valid credentials
        Then they should see the dashboard

    Scenario: User cannot log in with invlaid credentials
        Given a registered user
        When the user logs in with invalid credentials
        Then they should see an error message

    Scenario: User logs in with github
        Given I am authenticated with GitHub
        And the user logs in with github
        Then they should see github success

    Scenario: User logs in with google
        Given I am authenticated with Google
        And the user logs in with google 
        Then they should see google success