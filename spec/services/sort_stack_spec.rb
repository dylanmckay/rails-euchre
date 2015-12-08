
RSpec.describe SortStack do
  subject(:state) { GameState.new([], nil, :hearts) }
  describe "#call" do
    context "when sorting entire hands" do
      subject { SortStack.new(state,hand).call }

      context "and sorting a trump-filled hand" do
        let(:hand) {[
          Card.new(:hearts, 10 ),
          Card.new(:diamonds, 12),
          Card.new(:hearts, 12),
          Card.new(:hearts, 1 ),
          Card.new(:hearts, 13)
        ]}
        let (:sorted_hand) {[
          hand[3],
          hand[4],
          hand[2],
          hand[0],
          hand[1]
        ]}
        before {state.trump_suit = :hearts }

        it { is_expected.to eq sorted_hand}
      end

      context "and sorting a varied hand" do
        let (:hand) {[
          Card.new(:hearts, 10 ),
          Card.new(:diamonds, 12),
          Card.new(:hearts, 11),
          Card.new(:diamonds, 1 ),
          Card.new(:clubs, 13)
        ]}
        let (:sorted_hand) {[
          hand[2],
          hand[3],
          hand[1],
          hand[4],
          hand[0]
        ]}
        before {state.trump_suit = :diamonds}

        it { is_expected.to eq sorted_hand}
      end
    end
  end

  context "when comparing two cards" do
    subject { SortStack.new(state, [primary, other]).call.first }
    context "trump suit is spades" do
      before { state.trump_suit = :spades }
      trump_pair = :clubs

      context "when the card suits are: non-trump, following lead, and the same" do
        context "and the other's value is higher" do
          let(:primary) { Card.new(:hearts, 9) }
          let(:other)   { Card.new(:hearts, 10)}

          it { is_expected.to eq other }
        end


        context "and the primary is an ace" do
          let(:primary) { Card.new(:hearts, 1) }
          let(:other)   { Card.new(:hearts, 10)}

          it { is_expected.to eq primary }
        end

        context "and the primary is a queen and the other is a jack" do
          let(:primary) { Card.new(:hearts, 12) }
          let(:other)   { Card.new(:hearts, 11) }

          it { is_expected.to eq primary }
        end
      end

      context "when the card suits are: different, non-trump" do
        context "and the other doesn't follow the leading suit" do
          before { state.pile.add(Card.new(primary.suit, nil), nil)}
          let(:primary) { Card.new(:hearts, 11) }
          let(:other)   { Card.new(:diamonds, 12) }

          it { is_expected.to eq primary }
        end

        context "when other follows leading suit and primary doesn't" do
          before { state.pile.add(Card.new(other.suit, nil), nil)}
          let(:primary) { Card.new(:diamonds, 12) }
          let(:other)   { Card.new(:spades, 9) }

          it { is_expected.to eq other }
        end

        context "when the primary is trump and not-leading but other is leading" do
          before { state.trump_suit = :diamonds }
          before { state.pile.add(Card.new(other.suit, nil), nil)}
          let(:primary) { Card.new(:diamonds, 9) }
          let(:other)   { Card.new(:hearts, 1) }

          it { is_expected.to eq primary }
        end

        context "and neither follow the leading suit" do
          before { state.pile.add(Card.new(:hearts, nil), nil)}
          let(:primary) { Card.new(:diamonds, 12) }
          let(:other)   { Card.new(:clubs, 9) }

          it { is_expected.to eq primary }
        end
      end

      context "when the card suits are: trump, and the same " do
        before { state.trump_suit = :spades }

        context "and the primary card is a jack" do
          let(:primary) { Card.new(state.trump_suit, 11) }
          let(:other)   { Card.new(state.trump_suit, 12) }

          it { is_expected.to eq primary }
        end

        context "and the primary is the trump pair's jack and other is non jack trump" do
          let(:other)   { Card.new(state.trump_suit, 1) }
          let(:primary) { Card.new(other.partner_suit, 11) }

          it { is_expected.to eq primary }
        end

        context "and the primary and other are jack and pair jack" do
          let(:primary) { Card.new(state.trump_suit, 11) }
          let(:other)   { Card.new(trump_pair, 11) }

          it { is_expected.to eq primary }
        end
      end

      context "when the cards suits are: varying" do
        context " and the other is trump and not leading" do
          before { state.pile.add(Card.new(:hearts, nil), nil) }
          let(:primary) { Card.new(:hearts, 1) }
          let(:other)   { Card.new(state.trump_suit, 9) }

          it { is_expected.to eq other }
        end

        context "and the primary is non-leading and other is trump" do
          let(:primary) { Card.new(:hearts,1) }
          let(:other)   { Card.new(state.trump_suit,9) }

          it { is_expected.to eq other }
        end
      end
    end
  end
end
