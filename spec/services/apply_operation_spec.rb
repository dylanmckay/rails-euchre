require 'rails_helper'

describe ApplyOperation do
  def operation(player_id, type, suit=nil, rank=nil)
    op = create_operation(player_id, type, suit, rank)
    ApplyOperation.new(state, op).call
  end

  subject(:state) {
    create_custom_game_state(
      players: [
        {
          hand: [
            create_card(:hearts, 11),
            create_card(:spades, 8),
          ]
        },

        {
          hand: [
            create_card(:clubs, 10),
            create_card(:clubs, 9),
          ]
        },

        {
          hand: [
            create_card(:diamonds, 8),
            create_card(:hearts, 12),
          ]
        },
      ],
      trump_suit: :diamonds)
  }

  context "dealing a card" do
    let(:hand) { state.find_player(0).hand }

    subject {
      -> { operation(0, :deal_card, :spades, 13) }
    }

    it { is_expected.to change { hand.length }.by 1 }
  end

  context "passing trump" do
    subject {
      -> { operation(1, :pass_trump, :hearts, 10) }
    }

    it { is_expected.not_to change { state } }
    it { is_expected.to change { state.last_player }.to state.find_player(1) }
  end

  context "accepting a trump" do
    subject {
      -> { operation(2, :accept_trump) }
    }

    it { is_expected.to change{state.trump_state.suit}.to :diamonds }
    it { is_expected.to change { state.last_player }.to state.find_player(2) }
  end

  context "picking a trump" do
    subject {
      -> { operation(1, :pick_trump, :spades) }
    }

    it { is_expected.to change{state.trump_suit}.to :spades }
    it { is_expected.to change { state.last_player }.to state.find_player(1) }
  end

  context "playing a card" do
    subject {
      -> { operation(1, :play_card, :clubs, 10) }
    }

    let(:hand) { state.find_player(1).hand }

    it { is_expected.to change { state.pile.length }.by 1 }
    it { is_expected.to change { hand.length }.by(-1) }
    it { is_expected.to change { state.last_player }.to state.find_player(1) }

    context "finishing a trick" do

      subject {
        # play the second card and finish the round.
          operation(0, :play_card, :hearts, 11)
          operation(1, :play_card, :clubs, 10)
          -> {
            operation(2, :play_card, :hearts, 12)
          }
      }

      it { is_expected.to change { state.pile.length }.to 0 }
      it { is_expected.to change { state.last_player }.to state.find_player(2) }

      # TODO: check that the winners score is incremented
    end
  end

  context "finishing a round" do
    subject {
      operation(1, :play_card, :clubs, 10)
      operation(2, :play_card, :diamonds, 8)
      operation(0, :play_card, :hearts, 11)

      operation(1, :play_card, :clubs, 9)
      operation(2, :play_card, :hearts, 12)
      -> { operation(0, :play_card, :spades, 8) }
    }

    it { is_expected.to change { state.dealer } }
    it { is_expected.to change { state.last_player }.to state.find_player(0) }
  end
end
