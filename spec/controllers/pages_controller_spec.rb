require 'spec_helper'

describe PagesController do

  describe "GET 'front'" do
    it "returns http success" do
      get 'front'
      expect(response).to be_success
    end
  end

  describe "GET 'my_queue'" do
    it_behaves_like "require_signed_in" do
      let(:action) { get 'my_queue' }
    end

    context "signed in" do
      before do
        sign_in_user
        get 'my_queue'
      end

      it "renders my_queue template" do
        expect(response).to render_template(:my_queue)
      end

      it "sets @queue_items" do
        queue3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 3)
        queue1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 1)
        queue2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 2)

        expect(assigns(:queue_items)).to eq([queue1, queue2, queue3])
      end
    end

  end

end
