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

#