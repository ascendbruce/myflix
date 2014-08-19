require 'spec_helper'

describe Admin::VideosController do

  describe "GET 'new'" do
    it_behaves_like "require_signed_in" do
      let(:action) { get "new" }
    end

    it "sets the @video to a new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

    context "for regular users" do
      before do
        set_current_user
      end

      it "redirects to the home path" do
        get :new
        expect(response).to redirect_to home_path
      end

      it "sets the flash error message" do
        get :new
        expect(flash[:error]).to be_present
      end
    end
  end

end
