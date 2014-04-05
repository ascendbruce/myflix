require "spec_helper"

feature "Signing in" do
  given!(:user) { Fabricate(:user) }

  scenario "Signing in with correct credentials" do
    sign_in(user)

    expect(page).to have_content "You are signed in"
    expect(page).to have_content user.full_name
  end

  scenario "Signing in with wrong credentials" do
    visit sign_in_path

    within("form.sign_in") do
      fill_in "email",    with: user.email
      fill_in "password", with: "xxx#{user.password}"
    end

    click_button "Sign in"

    expect(page).to have_content "Invalid email or password"
  end
end
