# Login
Given("a registered user") do
    @user = create(:user)
end

When("the user logs in with valid credentials") do 
    visit new_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Login"
end

Then("they should see the dashboard") do
    expect(page).to have_content("You have successfully logged in, "+ @user.name)
end

When("the user logs in with invalid credentials") do
    visit new_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "wrongpassword"
    click_button "Login"
end

Then ("they should see an error message") do
    expect(page).to have_content("Invalid email or password")
end

# Signup

Given("the sign up page is open") do
    visit signup_path
end

When ("the user fills in the form with valid credentials") do
    fill_in "Name", with: "Test User"
    fill_in "Email", with: "Test@mail.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
end

And ("they submit the form") do 
    click_button "Create User"
end

Then ("they should see a success message") do
    expect(page).to have_content("Your account has been successfully created")
end

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

