require_relative '../../app/services/apply_action'
require_relative '../game_helper'

describe ApplyAction do

  subject(:game) {
    create_custom_game_state([
      {
        hand: [
          create_card(:hearts, 11),
          create_card,
        ]
      },

      {
        hand: [
          create_card(:clubs, 10),
          create_card,
        ]
      },

      {
        id: 5,
        hand: [
          create_card(:diamonds, 8),
          create_card,
        ]
      },
    ])
  }

  let(:action) { ApplyAction.new(game) }

  context "dealing a card" do
    let(:hand) { game.find_player(0).hand }

    subject {
      -> { action.call(create_action(0, :deal_card, :spades, 13)) }
    }

    it { is_expected.to change { hand.length }.by 1 }
  end

  context "passing trump" do
    subject {
      -> { action.call(create_action(1, :pass_trump, :hearts, 10)) }
    }

    it { is_expected.not_to change { game } }
  end

  context "accepting a trump" do
    subject {
      -> { action.call(create_action(2, :accept_trump, :diamonds)) }
    }

    it { is_expected.to change{game.trump_suit}.to :diamonds }
  end

  context "picking a trump" do
    subject {
      -> { action.call(create_action(1, :pick_trump, :spades)) }
    }

    it { is_expected.to change{game.trump_suit}.to :spades }
  end

  context "playing a card" do
    subject {
      -> { action.call(create_action(1, :play_card, :clubs, 10)) }
    }

    let(:hand) { game.find_player(1).hand }

    it { is_expected.to change { game.pile.length }.by 1 }

    it { is_expected.to change { hand.length }.by -1 }

    context "finishing a round" do
      before {
        # there are three players - play the first card
        action.call(create_action(1, :play_card, :clubs, 10))
        action.call(create_action(5, :play_card, :diamonds, 8))
      }

      subject {
        # play the second card and finish the round.
        -> { action.call(create_action(0, :play_card, :hearts, 11)) }
      }

      it { is_expected.to change { game.pile.length }.to 0 }
    end
  end
end
