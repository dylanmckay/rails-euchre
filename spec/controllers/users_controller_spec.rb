require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views

  let(:user) {
    User.create!(name: "Bill")
  }

  describe "#index" do
    it "is a success" do
      get :index
      expect(response).to be_success
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "#new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end

    it "is a success" do
      get :new
      expect(response).to be_success
    end
  end

  describe "#create" do
    it "creates a new user" do
      expect {
        get :create, user: { name: "Bill" }
      }.to change(User,:count).by 1
    end

    it "redirects to the new user" do
      get :create, user: { name: "Bill" }
      expect(response).to redirect_to User.last
    end
  end

  describe "#show" do
    it "renders the show template" do
      get :show, id: user
      expect(response).to render_template :show
    end

    it "is a success" do
      get :show, id: user
      expect(response).to be_success
    end
  end
end
