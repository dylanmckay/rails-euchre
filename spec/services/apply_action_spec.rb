require_relative '../../app/services/apply_action'
require_relative '../game_helper'

describe ApplyAction do

  subject(:game) { create_game_state(4) }
  let(:action) { ApplyAction.new(game) }

  context "passing trump" do
    subject {
      -> { action.call(create_action(Action::PASS_TRUMP, "HEARTS", 10)) }
    }

    it { is_expected.not_to change{game} }
  end

  context "accepting a trump" do
    subject {
      -> { action.call(create_action(Action::ACCEPT_TRUMP, "DIAMONDS")) }
    }

    it { is_expected.to change{game.trump_suit}.to "DIAMONDS" }
  end

  context "picking a trump" do
    subject {
      -> { action.call(create_action(Action::PICK_TRUMP, "SPADES")) }
    }

    it { is_expected.to change{game.trump_suit}.to "SPADES" }
  end

  context "when it encounters an unknown action type" do
    subject {
      -> { action.call(create_action("foo", "SPADES", 12)) }
    }

    it { is_expected.to raise_error(Exception) }
  end

end
