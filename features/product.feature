Feature: products

    Scenario: the user adds a product to the cart
        Given a registered user
        Given a product is created 
        And the user logs in with valid credentials
        And the user clicks on more info 
        And the user clicks on add to cart
        Then they should see added to cart
        And they click back 
        Then they should see the seller's profile
    
    Scenario: user uses add to cart instead of more info
        Given a registered user
        Given a product is created 
        And the user logs in with valid credentials
        And the user clicks on add to cart
        They should see added to cart