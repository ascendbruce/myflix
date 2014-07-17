require "spec_helper"

feature "User resets password" do

  scenario "user successfully resets the passowrd" do
    user = Fabricate(:user, password: "old_password")

    visit sign_in_path
    click_link "Forgot Password"

    fill_in "email", with: user.email
    click_button "Send Email"

    open_email(user.email)
    current_email.click_link "Reset My Password"


    fill_in "password", with: "new_password"
    click_button "Reset Password"

    fill_in "email",    with: user.email
    fill_in "password", with: "new_password"
    click_button "Sign in"

    expect(page).to have_content("Welcome, #{user.full_name}")

    clear_email
  end
end
