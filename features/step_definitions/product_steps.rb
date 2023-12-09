Given ("a product is created") do
    @product = create(:product)
end

When ("the user clicks on more info") do
    click_link "More Info"
end

When ("the user clicks on add to cart") do
    click_link "Add to Cart"
end

Then ("they should see added to cart") do
    expect(page).to have_content("Product added to cart")
end

Then ("they click back") do
    click_link "Back"
end

When ("the user clicks on the seller's name") do
    click_link @product.user.name
end

Then ("they should see the seller's profile") do 
    expect(page).to have_content(@product.user.name)
end

Then ("they should see the home page") do
    expect(page).to have_content("PRODUCTS")
end

Then ("they should see the product page") do
    expect(page).to have_content(@product.name)
end

Then ("they should see must sign in") do
    expect(page).to have_content("You need to sign in before accessing this page.")
end

And ("the user clicks on home") do 
    click_link "Home"
end

And ("the user loads the page") do
    visit root_path
end