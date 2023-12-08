Feature: User Authentication

    Scenario: User can log in 
        Given a registered user
        When the user logs in with valid credentials
        Then they should see the dashboard

    Scenario: User cannot log in with invlaid credentials
        Given a registered user
        When the user logs in with invalid credentials
        Then they should see an error message