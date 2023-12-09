# Home Page 

Given("the user clicks home button") do 
    visit root_path
end

Then ("they should see products") do 
    expect(page).to have_content("PRODUCTS")
end

Given ("the user clicks about") do
    visit about_path
end

Then ("they should see contact info and our goal") do
    expect(page).to have_content("Contact Info")
    expect(page).to have_content("Our Goal")
end

Given ("the user clicks cart") do
    visit cart_path(@user.id)
end

Then ("they should see their cart") do
    expect(page).to have_content(@user.name + "'s Cart")
end

And ("the user types the product name") do 
    fill_in "search", with: @product.name
end

And ("the user clicks search") do
    within "nav" do
        click_button "Search"
    end
end

And ("the user clicks search in the side bar") do
    within "aside" do
        click_button "Search"
    end
end

Then ("the user should see that product") do
    expect(page).to have_content(@product.name)
end

And ("the user types in the wrong product name") do
    fill_in "search", with: "wrong product name"
end

Given ("the user sets a price min and max") do 
    fill_in "min_price", with: 0
    fill_in "max_price", with: 100
end

And ("product price is out of range") do
    fill_in "min_price", with: 1000
    fill_in "max_price", with: 2000
end

Then ("the user should see no products found") do
    expect(page).to have_content("No products found")
end

Then ("expect user not to see the right product") do
    expect(page).not_to have_content(Product.last.name)
end

And ("the user selects a category") do
    within("nav form") do
        options = all('#category_id option').map(&:text)
        select options.first , from: "category_id"
    end
    @product.category_id = 1
end
And ("the user selects a category in side bar") do
    within("aside") do
        options = all('#category_id option').map(&:text)
        select options.first , from: "category_id"
    end
    @product.category_id = 1
end

And ("they select the wrong category") do
    FactoryBot.create(:product, name: "Test", category_id: 2)
    FactoryBot.create(:product, name: "Test2", category_id: 3)
    within("nav form") do
        select_box = find('#category_id')
        first_option = select_box.find('option:not(:disabled):not([value=""])')
        select first_option.text, from: "category_id"
    end
end

And ("the user selects a tag") do
    within("aside") do
        options = all('#tag_list option').map(&:text)
        select options.first , from: "tag_list"
    end
    @product.category_id = 1
end

