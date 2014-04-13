require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }

  it { should have_secure_password }

  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }
  it { should have_many(:following_relationships) }
  it { should have_many(:leading_relationships) }

  let!(:user) { Fabricate(:user) }

  context "queue_items_update_position_by" do
    it "skips if pass blank argument in" do
      expect(user.queue_items_update_position_by([])).to be_nil
    end
  end

  context "queued_video?" do
    it "reutrns true if the user did queue the video" do
      monk = Fabricate(:video, title: "Monk")
      Fabricate(:queue_item, user: user, video: monk)
      expect(user.queued_video?(monk)).to be_true
    end

    it "return false if the user did not queue the video" do
      south_park = Fabricate(:video, title: "South Park")
      expect(user.queued_video?(south_park)).to be_false
    end
  end
end
