require 'rails_helper'
require_relative '../game_helper'

describe GameState do
  let(:player_models){
    create_player_models(3)
  }
  let(:players) {[
      PlayerState.new(hand: create_hand, player: player_models[0]),
      PlayerState.new(player: player_models[1]),
      PlayerState.new(player: player_models[2]),
  ]}

  subject(:state) {
    create_game(
      players: players,
      dealer: players.sample,
      trump: :hearts
    )
  }

  let(:empty_state) {
    create_game(players: [], dealer: nil, trump: :hearts)
  }

  describe "#player_index" do
    context "when looking for an existing player" do
      it "return the correct index" do
        expect(state.player_index(player_models[0])).to eq 0
      end
    end

    context "when looking for a nonexistent player" do
      it "returns nil" do
        expect(state.player_index(nil)).to eq nil
      end
    end
  end

  describe "#main_player" do
    it "returns a human player" do
      expect(state.main_player.player.user).to be_human
    end
  end

  describe "#ai_players" do
    it "returns only AI players" do
      state.ai_players.each do |player|
        expect(player.player.user).to be_ai
      end
    end
  end

  describe "#round_leaders" do
    subject { state.round_leaders }

    context "when there are no leaders" do
      it { is_expected.to be_empty }
    end

    context "when there is one leader" do
      before {
        state.players.first.total_score += 10
      }

      it { is_expected.to eq [ state.players.first ] }
    end

    context "when there are two leaders" do
      before {
        state.players.take(2).each do |player|
          player.total_score += 10
        end
      }

      it { is_expected.to eq state.players.take(2) }
    end
  end

  describe "#valid_play?" do
    hand = [
      Card.new(:hearts, 10 ),
      Card.new(:diamonds, 12),
      Card.new(:hearts, 12),
      Card.new(:clubs, 1 ),
      Card.new(:hearts, 13)
    ]
    let (:player) { PlayerState.new(hand: hand, player: player_models[1]) }

    context "when leading card is regular card" do
      leading_card =  Card.new(:diamonds, 1)

      before { state.pile.add(leading_card, state.players.last) }

      it { is_expected.to be_valid_turn(player, hand[1]) }

      it { is_expected.to_not be_valid_turn(player, hand[3]) }

      it { is_expected.to_not be_valid_turn(player, hand[0]) }
    end
    context "when the leading card is a left bower" do
      leading_card =  Card.new(:diamonds, 11)

      before {
        state.pile.clear
        state.pile.add(leading_card, state.players.last)
      }

      it { is_expected.to be_valid_turn(player, hand[0]) }

      it { is_expected.to_not be_valid_turn(player, hand[1]) }
    end

    context "when the leading card is a regular jack" do
      leading_card =  Card.new(:clubs, 11)

      before {
        state.pile.clear
        state.pile.add(leading_card, state.players.last)
      }

      it { is_expected.to_not be_valid_turn(player, hand[0]) }

      it { is_expected.to be_valid_turn(player, hand[3]) }
    end

    context "when the player contains no cards that follow the leading suit" do
      leading_card =  Card.new(:spades, 11)

      before {
        state.pile.clear
        state.pile.add(leading_card, state.players.last)
      }
      hand.each do |card|
        it { is_expected.to be_valid_turn(player, card) }
      end
    end
  end

  describe "#round_in_progress?" do
    context "at the start of the game" do
      it { is_expected.to be_round_in_progress }
    end

    context "in an empty game" do
      let(:players) {[
        PlayerState.new(player: player_models.first),
        PlayerState.new(player: player_models.last ),
      ]}

      subject {
        create_game(players: players, dealer: players.first,
                      trump: :diamonds)
      }

      it { is_expected.not_to be_round_in_progress }
    end
  end

  describe "#valid_card?" do
    context "when the leading suit is the same as the trump suit" do
      before {
        state.trump_state.suit = :hearts
        state.pile.add(Card.new(:hearts, 9), state.players.first)
      }

      context "when the card is a trump" do
        subject { state.valid_card?(Card.new(:hearts, 10)) }

        it { is_expected.to eq true }
      end

      context "when the card is not a trump" do
        subject { state.valid_card?(Card.new(:spades, 1)) }

        it { is_expected.to eq false }
      end
    end
  end
end
