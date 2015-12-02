require 'rails_helper'

RSpec.describe "GenerateTurn" do
  describe "#call"do
    hand = [
      Card.new(:hearts, 10 ),
      Card.new(:diamonds, 12),
      Card.new(:hearts, 12),
      Card.new(:hearts, 1 ),
      Card.new(:hearts, 13)
    ]
    let (:player_state) { PlayerState.new(id: 10, name: "Jojo", hand: hand) }
    let (:game) { GameState.new([player_state]) }
    before { game.trump_suit = :hearts }
    subject { GenerateTurn.new(player_state,game).call }

    context "when the pile is empty" do
      it { is_expected.to eq hand[3] }
    end

    context "when the pile has low cards" do
      before { game.pile.add(Card.new(:hearts, 9), player_state) }

      it { is_expected.to eq hand[3] }
    end

    context "when the pile has high cards" do
      before { game.pile.add(Card.new(:hearts, 11), player_state) }

      it { is_expected.to eq hand[0] }
    end

    context "when the hand contains no leading-suit" do
      before { game.pile.add(Card.new(:clubs, 1), player_state) }

      it { is_expected.to eq hand[3]}
    end

    context "when the hand contains no leading-suit or trump" do
      before {
        game.trump_suit = :clubs
        game.pile.add(Card.new(:clubs, 1), player_state)
      }

      it { is_expected.to eq hand[1]}
    end
  end

  describe "#sort_stack" do #TODO remove sort_stack and its tests from generate_turn
    hand = [
      Card.new(:hearts, 10 ),
      Card.new(:diamonds, 12),
      Card.new(:hearts, 12),
      Card.new(:hearts, 1 ),
      Card.new(:hearts, 13)
    ]
    sorted_hand = [
      hand[3],
      hand[4],
      hand[2],
      hand[0],
      hand[1]
    ]
    let (:player_state) { PlayerState.new(id: 10, name: "Jojo", hand: hand) }
    let (:game) { GameState.new([player_state]) }
    before { game.trump_suit = :hearts }
    subject { GenerateTurn.new(player_state,game).sort_stack(hand) }

    context "sort a hand" do
      it { is_expected.to eq sorted_hand}
    end
  end
end
