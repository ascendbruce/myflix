require 'spec_helper'

describe QueueItemsController do
  describe "PUT 'update_my_queue'" do
    it "redirects to sign_in_path if not logged in" do
      put "update_my_queue"
      expect(response).to redirect_to(sign_in_path)
    end

    context "with authenticated user" do
      let!(:user)       { Fabricate(:user) }
      let!(:monk)       { Fabricate(:queue_item, user: user, video: Fabricate(:video, title: "Monk")) }
      let!(:south_park) { Fabricate(:queue_item, user: user, video: Fabricate(:video, title: "South Park")) }
      let!(:futurama)   { Fabricate(:queue_item, user: user, video: Fabricate(:video, title: "Futurama")) }
      let!(:monk_review) { Fabricate(:review, user: user, video: monk.video, rating: 1) }

      before do
        session[:user_id] = user.id
      end

      context "position" do
        it "saves the specified order" do
          put "update_my_queue", position: { monk.id => "1", south_park.id => "3", futurama.id => "2" }, rating: { monk.id => nil, south_park.id => nil, futurama.id => nil }
          expect(user.queue_items).to eq([monk, futurama, south_park])
        end

        it "does not raise exception even if position is not numeric" do
          put "update_my_queue", position: { monk.id => "A", south_park.id => "C", futurama.id => "B" }, rating: { monk.id => nil, south_park.id => nil, futurama.id => nil }
          expect(response).to redirect_to(my_queue_path)
        end

        it "does not save queue_item which is not own by the user" do
          another_uesr = Fabricate(:user)
          family_guy   = Fabricate(:queue_item, user: another_uesr, video: Fabricate(:video, title: "Family Guy"), position: 3)

          put "update_my_queue", position: { family_guy.id => "1", south_park.id => "3" }, rating: { family_guy.id => nil, south_park.id => nil }
          family_guy.reload

          expect(family_guy.position).to eq(3)
        end
      end

      context "rating" do
        it "updates rating if already have a review object" do
          expect{
            put "update_my_queue", position: { monk.id => "1" }, rating: { monk.id => "5" }
          }.to change{ monk.rating }.from(1).to(5)
        end

        it "creates review if not exists" do
          put "update_my_queue", position: { south_park.id => "1" }, rating: { south_park.id => "5" }
          south_park_review = Review.last
          expect(south_park_review.video).to  eq(south_park.video)
          expect(south_park_review.user).to   eq(user)
          expect(south_park_review.rating).to eq(5)
        end

        it "does not update reveiw with invalid input" do
          put "update_my_queue", position: { monk.id => "1" }, rating: { monk.id => "A" }
          expect(monk.rating).to eq(1)
        end

        it "does not create reveiw with invalid input" do
          expect {
            put "update_my_queue", position: { south_park.id => "1" }, rating: { south_park.id => "A" }
          }.to_not change { Review.count }
        end
      end

      it "redirects to my_queue_path" do
        put "update_my_queue", position: { monk.id => "1", south_park.id => "3", futurama.id => "2" }, rating: { monk.id => nil, south_park.id => nil, futurama.id => nil }
        expect(response).to redirect_to(my_queue_path)
      end
    end
  end

  describe "DELETE 'destroy'" do
    let!(:user)       { Fabricate(:user) }
    let!(:queue_item) { Fabricate(:queue_item, user: user) }

    it "redirects to sign_in_path for unauthenticated users" do
      delete "destroy", id: queue_item.id
      expect(response).to redirect_to(sign_in_path)
    end

    context "with authenticated user" do
      before do
        session[:user_id] = user.id
      end

      it "deletes the queue item" do
        delete "destroy", id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "does not delete the queue item if the user is not owner" do
        anothor_user = Fabricate(:user)
        session[:user_id] = anothor_user.id

        delete "destroy", id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end

      it "redirects to my_queue_path" do
        delete "destroy", id: queue_item.id
        expect(response).to redirect_to(my_queue_path)
      end
    end
  end
end
