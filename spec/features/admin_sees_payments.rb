require "spec_helper"

feature "Admin sees payments" do
  given!(:alice) { Fabricate(:user, full_name: "Alice Lee", email: "alice@example.com") }

  background do
    Fabricate(:payment, amount: 999, user: alice)
  end

  scenario "admin can see payments" do
    admin = Fabricate(:user, admin: true)
    sign_in admin

    visit admin_payments_path
    expect(page).to have_content "$9.99"
    expect(page).to have_content alice.full_name
    expect(page).to have_content alice.email
  end

  scenario "user cannot see payments" do
    user = Fabricate(:user)
    sign_in user

    visit admin_payments_path
    expect(page).not_to have_content "$9.99"
    expect(page).not_to have_content alice.full_name
    expect(page).not_to have_content alice.email

    expect(page).to have_content "You are not authorized to do that."
  end
end
