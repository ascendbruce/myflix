require "spec_helper"

feature "My Queue" do
  given!(:user) { Fabricate(:user) }

  given!(:category) { Fabricate(:category) }

  given!(:monk)       { Fabricate(:video, category: category, title: "Monk",       description: "Monk") }
  given!(:south_park) { Fabricate(:video, category: category, title: "South Park", description: "South Park") }
  given!(:futurama)   { Fabricate(:video, category: category, title: "Futurama",   description: "Futurama") }

  scenario "User can add, reorder videos in the queue" do
    # login
    sign_in(user)

    # go to home page
    # - add a video to my queue
    add_video_to_queue(monk)

    # go to my queue
    # - ensue the video is there
    visit my_queue_path
    within "article" do
      expect(page).to have_content monk.title
    end

    # click on the video to go to video#show
    # - ensure the video title is correct
    # - ensure that "+ my queue" link should be disapprear
    find_video_link(monk).click
    within ".video_info" do
      expect(page).to have_content monk.title
      expect(page).not_to have_content("+ My Queue")
    end

    # go to home page
    # - add more videos to my queue
    add_video_to_queue(south_park)
    add_video_to_queue(futurama)

    # go to my queue page
    # - reorder videos
    # - verify the order of results
    visit my_queue_path

    within "article" do
      set_video_position(monk,       2)
      set_video_position(south_park, 3)
      set_video_position(futurama,   1)
      click_button "Update Instant Queue"
    end

    within "article" do
      expect_video_in_position(futurama,   1)
      expect_video_in_position(monk,       2)
      expect_video_in_position(south_park, 3)
    end
  end

  def add_video_to_queue(video)
    visit home_path
    find_video_link(video).click
    click_link("+ My Queue")
  end

  def set_video_position(video, position)
    fill_in "position[#{video.id}]", with: position
  end

  def expect_video_in_position(video, position)
    expect(find("tbody>tr:nth(#{position})")).to have_content video.title
    expect(find("tbody>tr:nth(#{position})>td>input[type='text']").value).to eq(position.to_s)
  end
end

