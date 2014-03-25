require 'spec_helper'

describe QueueItem do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:video_id) }
  it { should validate_presence_of(:position) }

  it { should belong_to(:user) }
  it { should belong_to(:video) }

  context "rating" do
    let!(:user)       { Fabricate(:user) }
    let!(:video)      { Fabricate(:video) }
    let!(:queue_item) { Fabricate(:queue_item, video: video, user: user) }

    it "returns the user rating on the video" do
      Fabricate(:review, video: video, user: user, rating: 5)
      expect(queue_item.rating).to eq(Review.where(video: video, user: user).first.rating)
    end

    it "returns nil if the user didn't rate the video" do
      expect(queue_item.rating).to eq(nil)
    end
  end
end
