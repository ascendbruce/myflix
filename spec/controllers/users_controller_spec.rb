require 'spec_helper'

describe UsersController do
  describe "GET 'new'" do
    before do
      get 'new'
    end

    it "returns http success" do
      expect(response).to be_success
    end

    it "sets the @user" do
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST 'create'" do

    context "with duplicated email" do
    end

    context "with invalid input" do
      let(:user) { Fabricate(:user) }

      before do
        post "create", user: {
          email: user.email,
          password:  Faker::Internet.password,
          full_name: Faker.name
        }
      end

      it "renders 'new' template" do
        expect(response).to render_template(:new)
      end

      it "does not create user" do
        expect(User.count).to eq(1)
        expect(User.first).to eq(user)
      end
    end

    context "missing attribute" do
      let(:user) { Fabricate.build(:user) }

      before do
        post "create", user: {
          # email is missing
          password:  Faker::Internet.password,
          full_name: Faker.name
        }
      end

      it "renders 'new' template" do
        expect(response).to render_template(:new)
      end

      it "does not create user" do
        expect(User.count).to be_zero
      end
    end

    context "with valid input" do
      let(:user) { Fabricate.build(:user) }

      def post_user
        post "create", user: {
          email:     user.email,
          password:  user.password,
          full_name: user.full_name
        }
      end

      it "creates a user" do
        expect { post_user }.to change{ User.count }.by(1)
      end

      it "redirect to sign in page" do
        post_user
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end
