require 'rails_helper'

describe PlayerState do
  context "on a simple player state" do
    let(:state) {
      create_player_state(
        cards: [
          Card.new(:hearts, 1),
        ]
      )
    }

    describe "#has_card?" do
      context "when the player does not have the card" do
        it "returns false" do
          expect(state.has_card?(Card.new(:spades, 9))).to eq false
        end
      end

      context "when the player has the card" do
        it "returns true" do
          expect(state.has_card?(Card.new(:hearts, 1))).to eq true
        end
      end
    end
  end
end
