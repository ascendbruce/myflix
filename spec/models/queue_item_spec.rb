require 'spec_helper'

describe QueueItem do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:video_id) }
  it { should validate_presence_of(:position) }

  it { should belong_to(:user) }
  it { should belong_to(:video) }

  context "rating" do
    let(:user)       { Fabricate.build(:user) }
    let(:video)      { Fabricate.build(:video) }
    let(:review)     { Fabricate.build(:review,     video: video, user: user, rating: 5) }
    let(:queue_item) { Fabricate.build(:queue_item, video: video, user: user) }

    before do
      user.save
      video.save
      queue_item.save
    end

    it "returns the user rating on the video" do
      review.save
      expect(queue_item.rating).to eq(Review.where(video: video, user: user).first.rating)
    end

    it "returns nil if the user didn't rate the video" do
      expect(queue_item.rating).to eq(nil)
    end
  end
end
