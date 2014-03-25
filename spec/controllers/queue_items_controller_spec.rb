require 'spec_helper'

describe QueueItemsController do
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
