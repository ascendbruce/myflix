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
end
