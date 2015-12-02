require 'rails_helper'

describe Operation do

  describe "#card" do
    context "when the operation is passing a trump suit" do
      let(:operation) {
        Operation.create!(operation_type: :pass_trump,
                       suit: :diamonds)
      }

      it "should not have an associated card" do
        expect { operation.card }.to raise_error(RuntimeError)
      end

    end

    context "when the operation is playing a card" do
      let(:operation) {
        Operation.create!(operation_type: :play_card,
                       suit: :hearts, rank: 10)
      }

      it "should have an associated card" do
        expect(operation.card).to be_a(Card)
      end
    end

    context "when the card is being dealt" do
      let(:operation) {
        Operation.create!(operation_type: :deal_card,
                       suit: :spades, rank: 11)
      }

      it "should have an associated card" do
        expect(operation.card).to be_a(Card)
      end
    end
  end
end
