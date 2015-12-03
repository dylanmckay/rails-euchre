require 'rails_helper'
require_relative '../game_helper'

describe GameState do
  subject(:state) {
    GameState.new([
      PlayerState.new(id: 5, hand: create_hand, name: "Henry"),
      PlayerState.new(id: 10, name: "Harold"),
    ])
  }

  let(:empty_state) {
    create_game_state(0)
  }

  describe "#valid_play_card_turn?" do
    hand = [
      Card.new(:hearts, 10 ),
      Card.new(:diamonds, 12),
      Card.new(:hearts, 12),
      Card.new(:hearts, 1 ),
      Card.new(:hearts, 13)
    ]
    leading_card =  Card.new(:diamonds, 1)

    let (:player) { PlayerState.new(id: 5, hand: hand, name: "Jacob") }
    before { state.pile.add(leading_card, state.players.last) }

    it { is_expected.to be_valid_play_card_turn(player,hand[1],:diamonds) }

    it { is_expected.to_not be_valid_play_card_turn(player,hand[1],:hearts) }

    it { is_expected.to be_valid_play_card_turn(player,hand[1],:clubs) }
  end

  describe "#round_in_progress?" do
    context "at the start of the game" do
      it { is_expected.to be_round_in_progress }
    end

    context "in an empty game" do
      subject {
        GameState.new([
          PlayerState.new(id: 5,  name: "Henry"),
          PlayerState.new(id: 10, name: "Harold"),
        ])

        it { is_expected.to not_be_round_in_progress }
      }
    end
  end

  describe "#find_player" do
    context "when there is a player" do
      it "should find the hand" do
        expect(state.find_player(5)).to be_a PlayerState
      end
    end

    context "when there are no players" do
      it "should not find any hands" do
        expect(empty_state.find_player(5)).to be nil
      end
    end
  end

  describe "#calculate_points" do
    subject {
      state.players.map { |player| state.calculate_points(player) }
    }

    context "when one player has won all 5 tricks in the round" do
      tricks = 10.times.map{ Card.new(:hearts,1) }
      let(:state) {
        GameState.new([
          PlayerState.new(id: 5, scored_cards: tricks, name: "Phillipa"),
          PlayerState.new(id: 10, name: "Jordan")
        ])
      }

      it { is_expected.to eq [2,0] }
    end

    context "when one player has won 3 of 5 tricks in the round" do
      tricks = 10.times.map{ Card.new(:hearts, 1) }
      let(:state) {
        GameState.new([
          PlayerState.new(id: 5, scored_cards: tricks[0..6], name: "Jeff"),
          PlayerState.new(id: 10, scored_cards: tricks[7..10], name: "Ron"),
        ])
      }

      it { is_expected.to eq [1,0] }
    end
  end


end
