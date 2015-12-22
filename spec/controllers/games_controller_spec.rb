require 'rails_helper'
require_relative '../game_helper.rb'

RSpec.describe GamesController, type: :controller do
  render_views

  let(:game) {
    model = create_game_model(
      players: create_player_models(4),
    )
    model.players.first.operations.draw_trump.create!(suit: "hearts", rank: 1)
    model
  }

  describe "#create" do
    let(:user) { User.create!(name: "Bill") }

    it "creates a new game" do
      expect {
        post :create, user_id: user
      }.to change(Game,:count).by 1
    end

    it "redirects to the new game" do
      post :create, user_id: user
      expect(response).to redirect_to Game.last
    end

    it "advances the game" do
      expect_any_instance_of(AdvanceGame).to receive(:call).and_call_original
      post :create, user_id: user
    end
  end

  describe "#show" do
    it "renders the show template" do
      get :show, id: game
      expect(response).to render_template :show
    end

    it "is a success" do
      get :show, id: game
      expect(response).to be_success
    end
  end
end
