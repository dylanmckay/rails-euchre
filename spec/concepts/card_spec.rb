require_relative '../../app/concepts/card'

describe Card do
  let(:card1) { Card.new("DIAMONDS", 10) }
  let(:card2) { Card.new("DIAMONDS", 10) }
  let(:card3) { Card.new("HEARTS", 10) }
  let(:card4) { Card.new("SPADES", 11) }

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
  end
end
