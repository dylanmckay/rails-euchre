require 'rails_helper'

describe CreateGame do
  let(:user) {
    User.create!(name: "Bob")
  }

  subject(:game) {
    CreateGame.new(
      player_count: 4,
      user: user
    ).call
  }

  it { is_expected.to be_a Game }

  context "when creating the game with four players" do
    it "creates four players" do
      expect(game.players.size).to eq 4
    end

    before {
      DealCards.new(game, game_state: CreateGameState.new(game).call).call
    }

    it "deals each player unique cards" do

      dealt_cards = game.players.flat_map do |player|
        deals = player.operations.select(&:deal_card?)
        deals.map { |operation| operation.card }
      end

      expect(dealt_cards.uniq).to eq dealt_cards
    end

    it "chooses a dealer" do
      expect(game.initial_dealer).not_to be nil
    end
  end
end
