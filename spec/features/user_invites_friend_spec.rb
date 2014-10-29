require "spec_helper"

feature "User invites friend" do

  scenario "User successfully invites friend and invitations is accepted" do
    alice = Fabricate(:user, full_name: "Alice Wang")
    sign_in(alice)

    invite_a_friend
    sign_out

    StripeWrapper::Charge.stub(:create).and_return(true)
    friend_accepts_invitation_and_sign_up
    friend_sign_in
    invitee_should_follow(alice.full_name)
    sign_out

    sign_in(alice)
    inviter_should_follow("Landy Zhai")

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name",          with: "Landy Zhai"
    fill_in "Friend's Email Address", with: "landy@example.com"
    fill_in "Invitation Message",     with: "Please join MyFlix"
    click_button "Send Invitation"
  end

  def friend_accepts_invitation_and_sign_up
    open_email("landy@example.com")
    current_email.click_link "Accept this invitation"
    fill_in "Password",  with: "123456"
    fill_in "Full Name", with: "Landy Zhai"
    click_button "Sign Up"
  end

  def friend_sign_in
    within("form.sign_in") do
      fill_in "email",    with: "landy@example.com"
      fill_in "password", with: "123456"
    end
    click_button "Sign in"
  end

  def current_user_should_follow(another_user_full_name)
    click_link "People"
    expect(page).to have_content(another_user_full_name)
  end
  alias_method :inviter_should_follow, :current_user_should_follow
  alias_method :invitee_should_follow, :current_user_should_follow

end
