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

And ("check remember me") do
    check "Remember me"
end

Then ("they should see github success") do 
    expect(page).to have_content("You have signed up, Test User")
end

Then ("they should see google success") do
    expect(page).to have_content("You have signed up, Google User")
end

Given(/^I am authenticated with GitHub$/) do
    mock_github_auth_hash('test@example.com', 'Test User')
end
Given(/^I am authenticated with Google$/) do
    mock_google_auth_hash('google@example.com', 'Google User')
end

When ("the user logs in with google") do   
    visit new_session_path
    click_button "Google"
end

When ("the user logs in with github") do
    visit new_session_path
    click_button "Github"
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

