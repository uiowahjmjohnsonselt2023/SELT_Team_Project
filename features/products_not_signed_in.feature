Feature: not signed in     
    
    Scenario: User clicks add to cart without logging in 
        Given a product is created 
        Given a registered user
        And the user loads the page 
        And the user clicks on add to cart 
        Then they should see must sign in 

    Scenario Outline: User clicks Sellers name without logging in 
        Given a product is created 
        Given a registered user 
        And the user loads the page 
        And the user clicks on the seller's name 
        Then they should see must sign in 

    Scenario Outline: User clicks on add to cart on more info page
        Given a product is created 
        Given a registered user
        And the user loads the page 
        And the user clicks on more info 
        And the user clicks on add to cart 
        Then they should see must sign in 