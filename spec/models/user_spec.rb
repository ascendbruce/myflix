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

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end

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

  context "can_follow?" do
    let!(:leader) { Fabricate(:user, full_name: "Bob") }

    it "returns false if the user already followed the leader" do
      Fabricate(:relationship, follower: user, leader: leader)
      expect(user.can_follow?(leader)).to eq(false)
    end

    it "returns false if the leader is the user himself" do
      expect(user.can_follow?(user)).to eq(false)
    end

    it "reutrns true if the user can follow the leader" do
      expect(user.can_follow?(leader)).to eq(true)
    end
  end

  describe "#follow" do
    it "follows another user" do
      alice = Fabricate(:user)
      bob   = Fabricate(:user)
      alice.follow bob
      expect(alice.follows?(bob)).to be_true
    end

    it "does not follow one self" do
      alice = Fabricate(:user)
      alice.follow alice
      expect(alice.follows?(alice)).to be_false
    end
  end
end
