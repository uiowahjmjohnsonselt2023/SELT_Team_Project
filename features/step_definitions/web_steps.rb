# features/step_definitions/web_steps.rb
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