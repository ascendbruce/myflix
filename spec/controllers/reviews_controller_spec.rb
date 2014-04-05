require 'spec_helper'

describe ReviewsController do
  describe "POST 'create'" do

    context "not signed in" do
      let(:review) { Fabricate.build(:review, video: Fabricate(:video)) }

      before do
        post :create, video_id: review.video.id, review: { rating: review.rating, comment: review.comment }
      end

      it "does not create review" do
        expect(Review.last).not_to eq(review)
      end

      it "redirects back to sign_in_path" do
        expect(response).to redirect_to(sign_in_path)
      end

    end

    context "after signed in" do
      let(:video) { Fabricate(:video) }
      let(:user) { Fabricate(:user) }
      let(:review) { Fabricate.build(:review, id: 1, video: video, user: user) }


      context "with valid inputs" do
        before do
          set_current_user(user)
          post :create, video_id: review.video.id, review: { rating: review.rating, comment: review.comment }
        end

        it "creates reveiw" do
          expect(assigns(:new_review).errors.to_a).to  be_empty
          expect(Review.last).to eq(review)
        end

        it "redirect back to video show page" do
          expect(response).to redirect_to(video_path(review.video.id))
        end
      end

      context "with invalid inputs" do
        before do
          set_current_user(user)
          post :create, video_id: review.video.id, review: { rating: review.rating, comment: "" }
        end

        it "does not create reveiw" do
          expect(assigns(:new_review).errors.to_a).to be_present
          expect(Review.last).to be_nil
        end

        it "renders video show page" do
          expect(response).to render_template("videos/show")
        end
      end

    end
  end
end
