require_relative '../../app/concepts/game_state'
require_relative '../game_helper'

describe GameState do
  let(:game) {
    GameState.new([
      Hand.new(5, []),
      Hand.new(10, []),
    ])
  }

  let(:empty_game) {
    create_game_state(0)
  }

  describe "#find_player" do

    context "when there is a player" do
      it "should find the hand" do
        expect(game.find_hand(5)).to be_a Hand
      end
    end

    context "when there are no players" do
      it "should not find any hands" do
        expect(empty_game.find_hand(5)).to be nil
      end
    end
  end
end
