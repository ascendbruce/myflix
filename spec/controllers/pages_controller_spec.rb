require 'spec_helper'

describe PagesController do

  describe "GET 'front'" do
    it "returns http success" do
      get 'front'
      response.should be_success
    end
  end

  describe "GET 'my_queue'" do
    it "renders my_queue template" do
      get 'my_queue'
      expect(response).to render_template(:my_queue)
    end
  end

end
