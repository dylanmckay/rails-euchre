
RSpec.describe SortStack do
  subject(:state) { GameState.new([]) }
  describe "#call" do
    context "sort a trump-filled hand" do
      hand = [
        Card.new(:hearts, 10 ),
        Card.new(:diamonds, 12),
        Card.new(:hearts, 12),
        Card.new(:hearts, 1 ),
        Card.new(:hearts, 13)
      ]
      sorted_hand = [
        hand[3],
        hand[4],
        hand[2],
        hand[0],
        hand[1]
      ]
      before {state.trump_suit = :hearts }
      subject { SortStack.new(state,hand).call }

      it { is_expected.to eq sorted_hand}
    end

    context "sort a varied hand" do
      hand = [
        Card.new(:hearts, 10 ),
        Card.new(:diamonds, 12),
        Card.new(:hearts, 11),
        Card.new(:diamonds, 1 ),
        Card.new(:clubs, 13)
      ]
      sorted_hand = [
        hand[2],
        hand[3],
        hand[1],
        hand[4],
        hand[0]
      ]
      before {state.trump_suit = :diamonds}
      subject { SortStack.new(state,hand).call }

      it { is_expected.to eq sorted_hand}
    end
  end
end
