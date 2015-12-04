require 'rails_helper'

describe ApplyOperation do

  def operation(op)
    ApplyOperation.new(state, op).call
  end

  subject(:state) {
    create_custom_game_state([
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
        id: 5,
        hand: [
          create_card(:diamonds, 8),
          create_card(:hearts, 12),
        ]
      },
    ])
  }

  context "dealing a card" do
    let(:hand) { state.find_player(0).hand }

    subject {
      -> { operation(create_operation(0, :deal_card, :spades, 13)) }
    }

    it { is_expected.to change { hand.length }.by 1 }
  end

  context "passing trump" do
    subject {
      -> { operation(create_operation(1, :pass_trump, :hearts, 10)) }
    }

    it { is_expected.not_to change { state } }
  end

  context "accepting a trump" do
    subject {
      -> { operation(create_operation(2, :accept_trump, :diamonds)) }
    }

    it { is_expected.to change{state.trump_suit}.to :diamonds }
  end

  context "picking a trump" do
    subject {
      -> { operation(create_operation(1, :pick_trump, :spades)) }
    }

    it { is_expected.to change{state.trump_suit}.to :spades }
  end

  context "playing a card" do
    subject {
      -> { operation(create_operation(1, :play_card, :clubs, 10)) }
    }

    let(:hand) { state.find_player(1).hand }

    it { is_expected.to change { state.pile.length }.by 1 }

    it { is_expected.to change { hand.length }.by -1 }

    context "finishing a trick" do

      subject {
        # play the second card and finish the round.
        -> { operation(create_operation(0, :play_card, :hearts, 11)) }
      }

      it { is_expected.not_to change { state.pile.length } }
    end
  end

  # context "finishing a round" do
  #   subject {
  #     operation(create_operation(1, :play_card, :clubs, 10))
  #     operation(create_operation(5, :play_card, :diamonds, 8))
  #     operation(create_operation(0, :play_card, :hearts, 11))
  #
  #     operation(create_operation(1, :play_card, :clubs, 9))
  #     operation(create_operation(5, :play_card, :hearts, 12))
  #     -> { operation(create_operation(0, :play_card, :spades, 8)) }
  #   }
  #
  #   it { is_expected.to change { state.dealer } }
  # end
end
