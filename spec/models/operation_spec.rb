require 'rails_helper'
require 'spec_helper'

describe Operation do
  let(:card) { Card.new(:hearts, 10) }

  describe "scopes" do

    describe "deal_card" do
      subject(:operation) { Operation.deal_card.create!(card: card) }

      it { is_expected.to be_an Operation }

      it "has the right card" do
        expect(operation.card).to eq card
      end

      it "has the right operation type" do
        expect(operation.operation_type).to eq "deal_card"
      end
    end

    describe "pass_trump!" do
      subject(:operation) { Operation.pass_trump.create! }

      it { is_expected.to be_an Operation }

      it "has the right operation type" do
        expect(operation.operation_type).to eq "pass_trump"
      end
    end

    describe "accept_trump!" do
      subject(:operation) { Operation.accept_trump.create! }

      it { is_expected.to be_an Operation }

      it "has the right operation type" do
        expect(operation.operation_type).to eq "accept_trump"
      end
    end

    describe "pick_trump!" do
      subject(:operation) { Operation.pick_trump.create!(card: card) }

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
    subject(:operation) {
      Operation.play_card.create!(card: card)
    }

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
        Operation.pass_trump.create!
      }

      it "does not have an associated card" do
        expect { operation.card }.to raise_error(RuntimeError)
      end
    end
    context "when an invalid pass_trump operation is created" do
      let(:operation) {
        Operation.pass_trump.new(suit: :diamonds)
      }

      it "when an invalid operation is made" do
        expect(operation).to_not be_valid
      end
    end

    context "when a valid deal_card operation is created" do
      let(:operation) {
        Operation.pass_trump.new(suit: :diamonds, rank: 1)
      }

      it "when an valid operation is made" do
        expect(operation).to be_valid
      end
    end

    context "when the operation is playing a card" do
      let(:operation) {
        Operation.play_card.create!(card: card)
      }

      it "should have an associated card" do
        expect(operation.card).to be_a(Card)
      end
    end

    context "when the card is being dealt" do
      let(:operation) {
        Operation.deal_card.create!(card: card)
      }

      it "should have an associated card" do
        expect(operation.card).to be_a(Card)
      end
    end
  end

  describe "#suit_and_rank_are_mutually_existing" do
    subject { -> { model.save } }

    context "when the suit is set but the rank isn't" do
      let(:model) { Operation.play_card.new(suit: "hearts", rank: nil) }

      it { is_expected.to change { model.errors.size }.by 1 }
    end

    context "when the suit and the rank are both set" do
      let(:model) { Operation.play_card.new(suit: "hearts", rank: 1) }

      it { is_expected.not_to change { model.errors.size } }
    end
  end

  describe "#suit_is_null_or_valid" do
    subject { -> { model.save } }

    context "when the suit is null" do
      let(:model) { Operation.play_card.new(suit: nil) }

      it { is_expected.not_to change { model.errors.size } }
    end

    context "when the suit is valid" do
      let(:model) { Operation.play_card.new(suit: "hearts", rank: 13) }

      it { is_expected.not_to change { model.errors.size } }
    end

    context "when the suit is invalid" do
      let(:model) { Operation.play_card.new(suit: "qwerty", rank: 10) }

      it { is_expected.to change { model.errors.size }.by 1 }
    end
  end

  describe "#rank_is_null_or_allowed_in_euchre" do
    subject { -> { model.save } }

    context "when the rank is null" do
      let(:model) { Operation.play_card.new(suit: nil, rank: nil) }

      it { is_expected.not_to change { model.errors.size } }
    end

    context "when the rank is valid" do
      let(:model) { Operation.play_card.new(suit: "hearts", rank: 1) }

      it { is_expected.not_to change { model.errors.size } }
    end

    context "when the rank is invalid" do
      let(:model) { Operation.play_card.new(suit: "hearts", rank: 14) }

      it { is_expected.to change { model.errors.size }.by 1 }
    end
  end
end
