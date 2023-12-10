Feature: cart

    Background:
        Given a registered user
        Given a product is created
        And the user logs in with valid credentials
        And the user clicks on home 
        And the user clicks on add to cart
        And the user clicks cart

    Scenario: the user views the products in their cart
        Then the user should see that product
    
    Scenario: the user wants the remove that product
        Given the user should see that product
        And the user removes that product
        Then the user should see product removed
    

        