Feature: products

    Background: 
        Given a registered user
        Given a product is created
        And the user logs in with valid credentials
        And the user clicks on home 

    Scenario: the user adds a product to the cart
        And the user clicks on more info 
        And the user clicks on add to cart
        Then they should see added to cart
        And they click back 
        Then they should see the home page
    
    Scenario: user uses add to cart instead of more info
        And the user clicks on add to cart
        Then they should see added to cart

    Scenario: user clicks on seller's name on the product card
        And the user clicks on the seller's name 
        Then they should see the seller's profile 

    Scenario Outline: User clicks more info without logging in 
        Given a product is created 
        And the user clicks on more info 
        Then they should see the product page 
