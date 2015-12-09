require 'rails_helper'

describe CreateGame do

  it "creates a game object" do
    expect(CreateGame.new(2).call).to be_a Game
  end

  context "when creating the game with four players" do
    let(:game) { CreateGame.new(4).call }

    it "creates four players" do
      expect(game.players.size).to eq 4
    end

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

  context "when creating a game with an unspecified player name" do
    let(:game) { CreateGame.new(4).call }

    it "chooses a name for the player" do
      expect(!game.players.first.name.empty?)
    end
  end
end
