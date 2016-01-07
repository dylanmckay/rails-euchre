require 'rails_helper'
require 'spec_helper'

describe AdvanceGame do
  let(:players) {
    create_player_models(2)
  }

  let(:game) {
    create_game_model(
      players: players
    )
  }

  context "at the start of trump selection" do
    before {
      state = CreateGameState.new(game).call
      DealCards.new(game, game_state: state).call
    }

    it "will deal everybody cards" do
      expect_any_instance_of(DealCards).to receive(:call).and_call_original
      AdvanceGame.new(game).call
    end

    context "when all players pass in trump_selection" do

      before {
        players.each do |player|
          player.operations.pass_trump.create!
        end
        game.operations(reload: true)
      }

      it "will restart the round " do
        expect( ->{ AdvanceGame.new(game).call } ).to change { game.operations.length }.by 17
      end
    end
  end
end
