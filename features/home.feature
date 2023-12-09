Feature: Home page

    Scenario: the user clicks Home
        Given the user clicks home button
        Then they should see products
    
    Scenario: the user clicks About
        Given a registered user
        And the user logs in with valid credentials
        And the user clicks about 
        Then they should see contact info and our goal

    Scenario: the user clicks cart 
        Given a registered user
        And the user logs in with valid credentials
        And the user clicks cart 
        Then they should see their cart 