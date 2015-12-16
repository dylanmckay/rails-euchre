require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views

  describe "GET #index" do
    it "is a success" do
      get 'index'
      expect(response).to be_success
    end

  end
end
