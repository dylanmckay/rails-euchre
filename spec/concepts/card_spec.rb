require_relative '../../app/concepts/card'

describe Card do
  let(:card1) { Card.new(:diamonds, 10) }
  let(:card2) { Card.new(:diamonds, 10) }
  let(:card3) { Card.new(:hearts, 10) }
  let(:card4) { Card.new(:spades, 11) }
  let(:card5) { Card.new(:spades, 13) }

  describe "#==" do
    it "is equal to itself" do
      expect(card1 == card1).to be true
    end

    it "is equal to an equivalent card" do
      expect(card1 == card2).to be true
    end

    it "is not equal to a card with a different suit but same value" do
      expect(card1 == card3).to be false
    end

    it "is not equal to a card with a different suit and value" do
      expect(card1 == card4).to be false
    end

    it "is not equal to things that aren't cards" do
      expect(card1 == 10).to be false
    end
  end

  describe "#<=>" do
    context "when comparing a worse card with a better card" do
      subject { card3 <=> card4 }

      it { is_expected.to be < 0 }
    end

    context "when comparing a better card with a worse card" do
      subject { card5 <=> card1 }

      it { is_expected.to be > 0}
    end

    context "when comparing two cards of the same rank" do
      subject { card2 <=> card3 }

      it { is_expected.to be 0 }
    end

    context "when comparing two identical cards" do
      subject { card5 <=> card5 }

      it { is_expected.to be 0 }
    end
  end

  describe "#to_s" do
    it "prints the unicode character" do
      expect(card1.inspect).to eq "(10 of Diamonds)"
    end
  end

  describe "#inspect" do
    it "prints the same thing as to_s " do
      expect(card1.inspect).to eq card1.to_s
    end
  end
end
