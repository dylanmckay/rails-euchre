require 'rails_helper'
require_relative '../game_helper'

describe GameState do
  let(:players) {[
      PlayerState.new(id: 5, hand: create_hand, name: "Henry"),
      PlayerState.new(id: 10, name: "Harold"),
  ]}

  subject(:state) {
    GameState.new(players: players, dealer: players.sample,
                  trump_suit: :hearts)
  }

  let(:empty_state) {
    GameState.new(players: [], dealer: nil, trump_suit: :hearts)
  }

  describe "#valid_play?" do
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

    it { is_expected.to be_valid_turn(player, hand[1]) }

    it { is_expected.to_not be_valid_turn(player, hand[4]) }

    it { is_expected.to be_valid_turn(player, hand[1]) }
  end

  describe "#round_in_progress?" do
    context "at the start of the game" do
      it { is_expected.to be_round_in_progress }
    end

    context "in an empty game" do
      let(:players) {[
        PlayerState.new(id: 5,  name: "Henry"),
        PlayerState.new(id: 10, name: "Harold"),
      ]}

      subject {
        GameState.new(players: players, dealer: players.first,
                      trump_suit: :diamonds)
      }

      it { is_expected.not_to be_round_in_progress }
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
      let(:players) { [
          PlayerState.new(id: 5, scored_cards: tricks, name: "Phillipa"),
          PlayerState.new(id: 10, name: "Jordan"),
      ] }

      let(:state) {
        GameState.new(players: players, dealer: players.sample,
                      trump_suit: :clubs)
      }

      it { is_expected.to eq [2,0] }
    end

    context "when one player has won 3 of 5 tricks in the round" do
      tricks = 10.times.map{ Card.new(:hearts, 1) }
      let(:players) {[
          PlayerState.new(id: 5, scored_cards: tricks[0..6], name: "Jeff"),
          PlayerState.new(id: 10, scored_cards: tricks[7..10], name: "Ron"),
      ]}

      let(:state) {
        GameState.new(players: players, dealer: players.sample,
                      trump_suit: :hearts)
      }
      it { is_expected.to eq [1,0] }
    end
  end
end
