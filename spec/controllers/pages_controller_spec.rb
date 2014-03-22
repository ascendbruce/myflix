require 'spec_helper'

describe PagesController do

  describe "GET 'front'" do
    it "returns http success" do
      get 'front'
      response.should be_success
    end
  end

  describe "GET 'my_queue'" do
    context "without sign in" do
      it "redirect to sign_in_path" do
        get "my_queue"
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context "signed in" do
      let(:user) { Fabricate(:user) }

      before do
        session[:user_id] = user.id
        get 'my_queue'
      end

      it "renders my_queue template" do
        expect(response).to render_template(:my_queue)
      end

      it "sets @queue_items" do
        queue3 = Fabricate(:queue_item, video: Fabricate(:video), user: user, position: 3)
        queue1 = Fabricate(:queue_item, video: Fabricate(:video), user: user, position: 1)
        queue2 = Fabricate(:queue_item, video: Fabricate(:video), user: user, position: 2)

        expect(assigns(:queue_items)).to eq([queue1, queue2, queue3])
      end
    end

  end

end
