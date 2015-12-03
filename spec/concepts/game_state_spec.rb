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

  describe "#sort_stack" do
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
    before { state.trump_suit = :hearts }
    subject { state.sort_stack(hand) }

    context "sort a hand" do
      it { is_expected.to eq sorted_hand}
    end
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

  describe "#player_points" do
    subject{ state.player_points }

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

  describe "#best_card_in_stack" do
    let(:state) { GameState.new(nil) }
    context "when an all non-trump trick is played" do
      trick = [
        Card.new(:hearts, 9),
        Card.new(:hearts, 12),
        Card.new(:hearts, 10),
        Card.new(:hearts, 11)
      ]
      subject { state.best_card_in_stack(trick) }

      it { is_expected.to eq trick[1] }
    end

    context "when an all trump trick is played" do
      before { state.trump_suit = :hearts }

      trick = [
        Card.new(:hearts, 9),
        Card.new(:hearts, 12),
        Card.new(:hearts, 10),
        Card.new(:hearts, 11)
      ]
      subject { state.best_card_in_stack(trick) }

      it { is_expected.to eq trick[3] }
    end

    context "when a leading suit wins the trick" do
      before { state.trump_suit = :hearts }

      trick = [
        Card.new(:diamonds, 9),
        Card.new(:clubs, 12),
        Card.new(:spades, 10),
        Card.new(:diamonds, 10)
      ]
      subject { state.best_card_in_stack(trick) }

      it { is_expected.to eq trick[3] }
    end

    context "best card when other is leading" do
      before { state.trump_suit = :hearts }
      subject = Card.new(:clubs, 12)
      other = Card.new(:diamonds, 9)
      subject { state.highest_scoring_card(subject,other,:diamonds) }

      it { is_expected.to eq other }
    end

    context "when a non-leading trump wins the trick" do
      before { state.trump_suit = :hearts }

      trick =  [
        Card.new(:diamonds, 1),
        Card.new(:diamonds, 9),
        Card.new(:hearts, 11),
        Card.new(:clubs, 10)
      ]
      subject { state.best_card_in_stack(trick) }

      it { is_expected.to eq trick[2] }
    end

  end

  describe "#highest_scoring_card" do
    let(:state){ GameState.new(nil) }
    context "trump suit is spades" do
      before { state.trump_suit = :spades }
      trump_pair = :clubs

      context "when the card suits are: non-trump, following lead, and the same" do
        subject { state.highest_scoring_card(primary, other, primary.suit) }

        context "and the primary's value is higher" do
          let(:primary) { Card.new(:hearts, 9) }
          let(:other)   { Card.new(:hearts, 10)}

          it { is_expected.to eq other }
        end


        context "and the primary is an ace" do
          before { state.trump_suit = :diamonds }
          let(:primary) { Card.new(:hearts, 1) }
          let(:other)   { Card.new(:hearts, 10)}

          it { is_expected.to eq primary }
        end

        context "and the primary is a queen and the other is a jack" do
          let(:primary) { Card.new(:hearts, 12) }
          let(:other)   { Card.new(:hearts, 11) }

          it { is_expected.to eq primary }
        end

      end

      context "when the card suits are: different, non-trump" do
        subject { state.highest_scoring_card(primary, other, primary.suit) }

        context "and the other doesn't follow the leading suit" do
          let(:primary) { Card.new(:hearts, 11) }
          let(:other)   { Card.new(:diamonds, 12) }

          it { is_expected.to eq primary }
        end

        context "when other follows leading suit and primary doesn't" do
          subject { state.highest_scoring_card(primary, other, :spades) }
          let(:primary) { Card.new(:diamonds, 12) }
          let(:other)   { Card.new(:spades, 9) }

          it { is_expected.to eq other }
        end

        context "when the primary is trump and not-leading but other is leading" do
          before { state.trump_suit = :diamonds }
          subject { state.highest_scoring_card(primary, other, :hearts) }
          let(:primary) { Card.new(:diamonds, 9) }
          let(:other)   { Card.new(:hearts, 1) }

          it { is_expected.to eq primary }
        end

        context "and neither follow the leading suit" do
          subject { state.highest_scoring_card(primary, other, :hearts) }
          let(:primary) { Card.new(:diamonds, 12) }
          let(:other)   { Card.new(:clubs, 9) }

          it { is_expected.to eq primary }
        end
      end

      context "when the card suits are: trump, and the same " do
        before { state.trump_suit = :spades }
        subject { state.highest_scoring_card(primary, other, primary.suit) }

        context "and the primary card is a jack" do
          let(:primary) { Card.new(state.trump_suit, 11) }
          let(:other)   { Card.new(state.trump_suit, 12) }

          it { is_expected.to eq primary }
        end

        context "and the primary is the trump pair's jack and other is non jack trump" do
          let(:primary) { Card.new(trump_pair, 11) }
          let(:other)   { Card.new(state.trump_suit, 1) }

          it { is_expected.to eq primary }
        end

        context "and the primary and other are jack and pair jack" do
          let(:primary) { Card.new(state.trump_suit, 11) }
          let(:other)   { Card.new(trump_pair, 11) }

          it { is_expected.to eq primary }
        end
      end

      context "when the cards suits are: varying" do
        subject { state.highest_scoring_card(primary, other, primary.suit) }
        context " and the other is trump and not leading" do
          let(:primary) { Card.new(:hearts, 1) }
          let(:other)   { Card.new(state.trump_suit, 9) }

          it { is_expected.to eq other }
        end

        context " primary is trump pair's jack and other is trump" do
          let(:primary) { Card.new(trump_pair, 11) }
          let(:other)   { Card.new(state.trump_suit, 1) }

          it { is_expected.to eq primary }
        end

        context "and the primary is non-leading and other is trump" do
          let(:primary) { Card.new(:hearts,1) }
          let(:other)   { Card.new(state.trump_suit,9) }

          it { is_expected.to eq other }
        end
      end
    end
  end
end
