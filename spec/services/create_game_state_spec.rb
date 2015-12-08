require 'rails_helper'

describe CreateGameState do
  context "when using a game model with two players" do

    let(:model) {
      Game.create!(players: [
        Player.create!(id: 0, name: "Rob"),
        Player.create!(id: 1, name: "Jim"),
      ],
      initial_dealer_id: 0,
      initial_trump: "hearts")
    }

    subject(:state) { CreateGameState.new(model).call }

    it "creates a state with two players" do
      expect(state.players.length).to eq 2
    end

    it "sets the initial dealer" do
      puts "state.dealer: #{state.dealer}"
      expect(state.dealer.id).to eq 0
    end
  end
end
