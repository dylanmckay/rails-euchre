#compare_card_spec.rb
require_relative '../../app/services/compare_card'
require_relative '../../app/concepts/card'

RSpec.describe "CardCompare" do
  subject(:comp){ CompareCard.new}

  describe "#call" do
    context "trump suit is spades" do
      trump = "SPADES"
      trump_pair = "CLUBS"

      context "when the card suits are: non-trump, following lead, and the same" do
        subject { comp.call(primary, other, trump, primary.suit) }

        context "and the primary's value is higher" do
          let(:primary) { Card.new("HEARTS",9) }
          let(:other) { Card.new("HEARTS",10)}

          it { is_expected.to eq other }
        end

        context "and the primary is an ace" do
          trump = "DIAMONDS"
          let(:primary) { Card.new("HEARTS",1) }
          let(:other) { Card.new("HEARTS",10)}

          it { is_expected.to eq primary }
        end

        context "and the primary is a queen and the other is a jack" do
          let(:primary) { Card.new("HEARTS",12) }
          let(:other) { Card.new("HEARTS",11)}
          it { is_expected.to eq primary }
        end

      end

      context "when the card suits are: different, non-trump" do
        subject { comp.call(primary, other, "CLUBS", primary.suit) }

        context "and the other doesn't follow the leading suit" do
          let(:primary) { Card.new("HEARTS",11) }
          let(:other) { Card.new("DIAMONDS",12)}

          it { is_expected.to eq primary }
        end

        context "when other follows leading suit and primary doesn't" do
          subject { comp.call(primary, other, "HEARTS", "SPADES") }
          let(:primary) { Card.new("DIAMONDS",12)}
          let(:other) { Card.new("SPADES",9) }

          it { is_expected.to eq other }
        end

        context "when the primary is trump and not-leading but other is leading" do
          subject { comp.call(primary, other, "DIAMONDS", "HEARTS") }
          let(:primary) { Card.new("DIAMONDS",9)}
          let(:other) { Card.new("HEARTS",1) }

          it { is_expected.to eq primary }
        end

        context "and neither follow the leading suit" do
          subject { comp.call(primary, other, "SPADES", "HEARTS") }
          let(:primary) { Card.new("DIAMONDS",12)}
          let(:other) { Card.new("CLUBS",9) }

          it { is_expected.to eq primary }
        end
      end

      context "when the card suits are: trump, and the same " do
        trump = "SPADES"
        subject { comp.call(primary, other, trump, primary.suit) }

        context "and the primary card is a jack" do
          let(:primary) { Card.new(trump,11) }
          let(:other) { Card.new(trump,12)}

          it { is_expected.to eq primary }
        end

        context "and the primary is the trump pair's jack and other is non jack trump" do
          let(:primary) { Card.new(trump_pair,11) }
          let(:other) { Card.new(trump,1)}

          it { is_expected.to eq primary }
        end

        context "and the primary and other are jack and pair jack" do
          let(:primary) { Card.new(trump,11) }
          let(:other) { Card.new(trump_pair,11)}

          it { is_expected.to eq primary }
        end
      end

      context "when the cards suits are: varying" do
        subject { comp.call(primary, other, trump, primary.suit) }
        context " and the other is trump and not leading" do
          let(:primary) { Card.new("HEARTS",1) }
          let(:other) { Card.new(trump,9) }

          it { is_expected.to eq other}
        end

        context " primary is trump pair's jack and other is trump" do
          let(:primary) { Card.new(trump_pair,11) }
          let(:other) { Card.new(trump,1) }

          it { is_expected.to eq primary}
        end

        context "and the primary is non-leading and other is trump" do
          let(:primary) { Card.new("HEARTS",1) }
          let(:other) { Card.new(trump,9) }

          it { is_expected.to eq other}
        end

        context "and the trump is an invalid suit" do
          subject { -> {comp.call(primary, other, "trump", primary.suit)} }
          let(:primary) { Card.new("HEARTS",1) }
          let(:other) { Card.new(trump,9) }

          it { is_expected.to raise_error(Exception)}
        end
      end
    end
  end
end
