require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views

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
end
