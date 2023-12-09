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

Then ("the user should see that product") do
    expect(page).to have_content(@product.name)
end

And ("the user types in the wrong product name") do
    fill_in "search", with: "wrong product name"
end

Then ("the user should see no products found") do
    expect(page).to have_content("No products found")
end

And ("the user selects a category") do
    within("nav form") do
        options = all('#category_id option').map(&:text)
        puts "Available options: #{options}"
        select options.first , from: "category_id"
    end
    @product.category_id = 1
end

And ("they select the wrong category") do
    within("nav form") do
        options = all('#category_id option').map(&:text)
        puts "Available options: #{options}"
        select options.first , from: "category_id"
    end
    @product.category_id = 2
end


