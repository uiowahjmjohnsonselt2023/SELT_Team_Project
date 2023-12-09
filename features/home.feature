Feature: Home page

    Background:
        Given a registered user 
        Given a product is created

    Scenario: the user clicks Home
        Given the user clicks home button
        Then they should see products
    
    Scenario: the user clicks About
        And the user logs in with valid credentials
        And the user clicks about 
        Then they should see contact info and our goal

    Scenario: the user clicks cart 
        And the user logs in with valid credentials
        And the user clicks cart 
        Then they should see their cart 

    Scenario: the user uses the search bar 
        Given the user loads the page  
        And the user types the product name 
        And the user clicks search
        Then the user should see that product

    Scenario: the user searchs by category 
        Given the user loads the page 
        And the user selects a category 
        And the user clicks search 
        Then the user should see that product

    Scenario: the user sets a price filter
        Given the user loads the page
        And the user sets a price min and max 
        And the user clicks search 
        Then the user should see that product

    Scenario: the user selects a tag
        Given the user loads the page 
        And the user selects a tag 
        And the user clicks search 
        Then the user should see that product

    Scenario: no products with that tag
        Given the user loads the page  
        And the user selects a tag 
        And the user clicks search 
        Then the user should see no products found 

    Scenario: no products with that category
        Given the user loads the page 
        And the user selects a category 
        And the user clicks search 
        Then the user should see no products found 

    Scenario: no products in that price range
        Given the user loads the page   
        And the user selects a price min and max 
        And the user clicks search 
        Then the user should see no products found

    Scenario: the user types in the wrong product name 
        Given the user loads the page
        And the user types the wrong product name 
        And the user clicks search
        Then the user should see no products found

    
