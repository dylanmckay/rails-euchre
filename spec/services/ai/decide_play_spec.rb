require 'rails_helper'

RSpec.describe AI::DecidePlay do
  subject { AI::DecidePlay.new(player_state,state).call }
  describe "#call"do
    let(:hand) {[
      Card.new(:hearts, 10 ),
      Card.new(:diamonds, 12),
      Card.new(:hearts, 12),
      Card.new(:hearts, 1 ),
      Card.new(:hearts, 13)
    ]}
    let (:player_state) { PlayerState.new(id: 10, name: "Jojo", hand: hand) }
    let (:state) { GameState.new([player_state]) }
    before { state.trump_suit = :hearts }

    context "when the pile is empty" do
      it { is_expected.to eq hand[3] }
    end

    context "when the pile has low cards" do
      before { state.pile.add(Card.new(:hearts, 9), player_state) }

      it { is_expected.to eq hand[3] }
    end

    context "when the pile has high cards" do
      before { state.pile.add(Card.new(:hearts, 11), player_state) }

      it { is_expected.to eq hand[0] }
    end

    context "when the hand contains no leading-suit" do
      before { state.pile.add(Card.new(:clubs, 1), player_state) }

      it { is_expected.to eq hand[3]}
    end

    context "when the hand contains no leading-suit or trump" do
      before {
        state.trump_suit = :clubs
        state.pile.add(Card.new(:clubs, 1), player_state)
      }

      it { is_expected.to eq hand[0] }
    end
  end
end
