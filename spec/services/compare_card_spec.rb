#compare_card_spec.rb
require_relative '../../app/services/compare_card'
require_relative '../../app/concepts/card'

RSpec.describe "CardCompare" do
  subject(:comp){ CompareCard.new}

  describe "#call" do
    context "trump suit is spades" do
      trump = :spades
      trump_pair = :clubs

      context "when the card suits are: non-trump, following lead, and the same" do
        subject { comp.call(primary,other,trump,primary.suit) }

        context "and the primary's value is higher" do
          let(:primary) { Card.new(:hearts,9) }
          let(:other)   { Card.new(:hearts,10)}

          it { is_expected.to eq other }
        end

        context "and the primary is an ace" do
          trump = :diamonds
          let(:primary) { Card.new(:hearts,1) }
          let(:other)   { Card.new(:hearts,10)}

          it { is_expected.to eq primary }
        end

        context "and the primary is a queen and the other is a jack" do
          let(:primary) { Card.new(:hearts,12) }
          let(:other)   { Card.new(:hearts,11)}

          it { is_expected.to eq primary }
        end

      end

      context "when the card suits are: different, non-trump" do
        subject { comp.call(primary, other, :clubs, primary.suit) }

        context "and the other doesn't follow the leading suit" do
          let(:primary) { Card.new(:hearts,11) }
          let(:other)   { Card.new(:diamonds,12)}

          it { is_expected.to eq primary }
        end

        context "when other follows leading suit and primary doesn't" do
          subject { comp.call(primary, other, :hearts, :spades) }
          let(:primary) { Card.new(:diamonds,12)}
          let(:other)   { Card.new(:spades,9) }

          it { is_expected.to eq other }
        end

        context "when the primary is trump and not-leading but other is leading" do
          subject { comp.call(primary, other, :diamonds, :hearts) }
          let(:primary) { Card.new(:diamonds,9)}
          let(:other)   { Card.new(:hearts,1) }

          it { is_expected.to eq primary }
        end

        context "and neither follow the leading suit" do
          subject { comp.call(primary, other, :spades, :hearts) }
          let(:primary) { Card.new(:diamonds,12)}
          let(:other)   { Card.new(:clubs,9) }

          it { is_expected.to eq primary }
        end
      end

      context "when the card suits are: trump, and the same " do
        trump = :spades
        subject { comp.call(primary, other, trump, primary.suit) }

        context "and the primary card is a jack" do
          let(:primary) { Card.new(trump,11) }
          let(:other)   { Card.new(trump,12)}

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
          let(:primary) { Card.new(:hearts,1) }
          let(:other) { Card.new(trump,9) }

          it { is_expected.to eq other}
        end

        context " primary is trump pair's jack and other is trump" do
          let(:primary) { Card.new(trump_pair,11) }
          let(:other) { Card.new(trump,1) }

          it { is_expected.to eq primary}
        end

        context "and the primary is non-leading and other is trump" do
          let(:primary) { Card.new(:hearts,1) }
          let(:other) { Card.new(trump,9) }

          it { is_expected.to eq other}
        end
      end
    end
  end
end
