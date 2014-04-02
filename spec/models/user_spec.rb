require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }

  it { should have_secure_password }

  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }

  let!(:user) { Fabricate(:user) }

  context "queue_items_update_position_by" do
    it "skips if pass blank argument in" do
      expect(user.queue_items_update_position_by([])).to be_nil
    end
  end
end
