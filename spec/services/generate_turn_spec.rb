require 'rails_helper'

RSpec.describe "GenerateTurn" do
  describe "#call"do
    hand = [
      Card.new(:hearts, 9 ),
      Card.new(:hearts, 12),
      Card.new(:hearts, 10),
      Card.new(:hearts, 1 ),
      Card.new(:hearts, 13)
    ]
    player_state = PlayerState.new(id: 10, name: "jojo", hand: hand)
    game = GameState.new([player_state])
    game.trump_suit = :hearts

    subject { GenerateTurn.new(player_state,game).call }

    context "when the pile is empty" do
      it { is_expected.to eq hand[3] }
    end

    context "when the pile has low cards" do
      before { game.pile.add(Card.new(:diamonds, 9), player_state) }

      it{ is_expected.to eq hand[3] }
    end

    context "when the pile has high cards" do
      before { game.pile.add(Card.new(:hearts, 11), player_state) }

      it{ is_expected.to eq hand[0] }
    end
  end
end
