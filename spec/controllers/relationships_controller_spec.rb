require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships for current_user's following relationships" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)

      set_current_user(alice)

      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "require_signed_in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    let!(:relationship) { Fabricate(:relationship) }

    it_behaves_like "require_signed_in" do
      let(:action) { delete :destroy, id: relationship.id }
    end

    context "user signed in" do
      let!(:follower) { Fabricate(:user, full_name: "Alice") }
      let!(:leader)   { Fabricate(:user, full_name: "Bob") }
      let!(:relationship) { Fabricate(:relationship, follower: follower, leader: leader) }
      before { set_current_user(follower) }

      it "deletes the relationship if the current_user is to follower" do
        delete :destroy, id: relationship
        expect(Relationship.count).to eq(0)
      end

      it "redirects to the people_path" do
        delete :destroy, id: relationship
        expect(response).to redirect_to(people_path)
      end

      it "does not delete the relationship which the current_user is not the followr" do
        not_my_relationship = Fabricate(:relationship, follower: leader, leader: follower)

        delete :destroy, id: not_my_relationship
        expect(Relationship.count).to eq(2)
      end
    end
  end

  describe "POST create" do
    it_behaves_like "require_signed_in" do
      let(:action) { post :create }
    end

    context "user signed in" do
      let!(:follower)       { Fabricate(:user, full_name: "Alice") }
      let!(:to_be_followed) { Fabricate(:user, full_name: "Bob") }
      before { set_current_user(follower) }

      it "creates relationship that the current_user follows the leader" do
        post :create, leader_id: to_be_followed.id
        expect(Relationship.count).to eq(1)
      end

      it "redirects to the people_path" do
        post :create, leader_id: to_be_followed.id
        expect(response).to redirect_to(people_path)
      end

      it "does not create relationship if the user already followed the leader" do
        Fabricate(:relationship, follower: follower, leader: to_be_followed)
        post :create, leader_id: to_be_followed.id
        expect(Relationship.count).to eq(1)
      end

      it "does not create relationship for the user himself" do
        post :create, leader_id: current_user.id
        expect(Relationship.count).to eq(0)
      end
    end
  end
end
