require 'spec_helper'

describe QueueItem do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:video_id) }
  it { should validate_presence_of(:position) }

  it { should belong_to(:user) }
  it { should belong_to(:video) }
end
