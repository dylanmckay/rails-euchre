require 'rails_helper'

describe Operation do
  let(:card) { Card.new(:hearts, 10) }

  describe "scopes" do

    describe "deal_card!" do
      subject(:operation) { Operation.deal_card!(card) }

      it { is_expected.to be_an Operation }

      it "has the right card" do
        expect(operation.card).to eq card
      end

      it "has the right operation type" do
        expect(operation.operation_type).to eq "deal_card"
      end
    end

    describe "pass_trump!" do
      subject(:operation) { Operation.pass_trump! }

      it { is_expected.to be_an Operation }

      it "has the right operation type" do
        expect(operation.operation_type).to eq "pass_trump"
      end
    end

    describe "accept_trump!" do
      subject(:operation) { Operation.accept_trump! }

      it { is_expected.to be_an Operation }

      it "has the right operation type" do
        expect(operation.operation_type).to eq "accept_trump"
      end
    end

    describe "pick_trump!" do
      subject(:operation) { Operation.pick_trump!(card) }

      it { is_expected.to be_an Operation }

      it "has the right operation type" do
        expect(operation.operation_type).to eq "pick_trump"
      end

      it "has the right card" do
        expect(operation.card).to eq card
      end
    end
  end

  describe "play_card!" do
    subject(:operation) { Operation.play_card!(card) }

    it { is_expected.to be_an Operation }

    it "has the right operation type" do
      expect(operation.operation_type).to eq "play_card"
    end

    it "has the right card" do
      expect(operation.card).to eq card
    end
  end

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
