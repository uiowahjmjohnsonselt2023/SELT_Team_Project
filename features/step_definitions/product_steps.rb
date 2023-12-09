Given ("a product is created") do
    @product = create(:product)
end

When ("the user clicks on more info") do
    visit product_path(@product.id)
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

Then ("they should see the seller's profile") do
    expect(page).to have_content(@product.user.name)
end