require 'rails_helper'

describe CreateGameState do
  context "when using a game model with two players" do

    let(:model) {
      Game.create!(players: [
        Player.create!(id: 0, name: "Rob"),
        Player.create!(id: 1, name: "Jim"),
      ],
      initial_dealer_id: 0,)
    }

    subject(:state) { CreateGameState.new(model).call }

    it "creates a state with two players" do
      expect(state.players.length).to eq 2
    end
  end
end
