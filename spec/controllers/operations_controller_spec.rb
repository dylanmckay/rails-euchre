require 'rails_helper'

RSpec.describe OperationsController, type: :controller do
  let(:game) {
    model = create_game_model(
      players: create_player_models(4),
    )
    model.players.first.operations.draw_trump.create!(suit: "hearts", rank: 1)
    model
  }

  describe "#new" do
    it "creates at least one operation" do
      expect {
        get :new, game_id: game, player_id: game.players.first, operation_type: "pass_trump"
      }.to change(Operation, :count)
    end

    it "advances the game" do
      expect_any_instance_of(AdvanceGame).to receive(:call).and_call_original
      get :new, game_id: game, player_id: game.players.first, operation_type: "pass_trump"
    end

    it "redirects back to the game" do
      get :new, game_id: game, player_id: game.players.first, operation_type: "pass_trump"
      expect(response).to redirect_to game
    end
  end
end
