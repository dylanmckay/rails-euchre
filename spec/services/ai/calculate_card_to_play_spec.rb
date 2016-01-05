require 'rails_helper'

RSpec.describe AI::CalculateCardToPlay do
  subject {
    AI::CalculateCardToPlay.new(game_state, ai_state).call
  }

  describe "#call"do
    let(:hand) {[
      Card.new(:hearts,   10),
      Card.new(:diamonds, 12),
      Card.new(:hearts,   12),
      Card.new(:hearts,   1),
      Card.new(:hearts,   13)
    ]}
    let (:ai_player) { Player.new(user: User.new(name: "Jono", ai: true)) }
    let (:ai_state) { PlayerState.new(player: ai_player, hand: hand) }
    let (:game_state) {
      create_game(
        players: [ai_state],
        dealer: ai_state,
        trump: :hearts
      )
    }

    before { game_state.trump_state.suit = :hearts }

    context "when the pile is empty" do
      it { is_expected.to eq hand[3] }
    end

    context "when the pile has low cards" do
      before { game_state.pile.add(Card.new(:hearts, 9), ai_state) }

      it { is_expected.to eq hand[3] }
    end

    context "when the pile has high cards" do
      before { game_state.pile.add(Card.new(:hearts, 11), ai_state) }

      it { is_expected.to eq hand[0] }
    end

    context "when the hand contains no leading-suit" do
      before { game_state.pile.add(Card.new(:clubs, 1), ai_state) }

      it { is_expected.to eq hand[3]}
    end

    context "when the hand contains no leading-suit or trump" do
      before {
        game_state.trump_state.suit = :clubs
        game_state.pile.add(Card.new(:clubs, 1), ai_state)
      }

      it { is_expected.to eq hand[0] }
    end
  end
end
