require "spec_helper"

feature "My Queue" do

  scenario "User follows and unfollows someone" do
    follower  = Fabricate(:user, full_name: "Alice")
    leader    = Fabricate(:user, full_name: "Bob")
    monk      = Fabricate(:video, category: Fabricate(:category), title: "Monk", description: "Monk")

    Fabricate(:review, video: monk, user: leader)

    # login
    sign_in(follower)

    # visit home page and navigate to an video
    visit home_path
    find_video_link(monk).click

    # one of review -> user profile
    click_link leader.full_name

    # follow the person
    click_link "Follow"

    # ensue the person is in list
    expect(page).to have_content(leader.full_name)

    # unfollow the person and make sure that the person is unfollowed
    unfollow(follower, leader)
    expect(page).not_to have_content(leader.full_name)
  end

  def unfollow(follower, leader)
    relationship = Relationship.where(follower: follower, leader: leader).first
    find("a[data-method='delete'][href='#{relationship_path(relationship)}']").click
  end
end
