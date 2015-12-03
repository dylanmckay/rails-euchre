RSpec.describe CalculateCardValue do
  let(:game_state) { GameState.new([]) }
  card = Card.new(:hearts, 1)
  subject { CalculateCardValue.new(game_state,card).call }

  context "when a non-trump card is used" do
    before { card = Card.new(:hearts, 9) }

    it{ is_expected.to eq 9}
  end

  context "when an ace, non-trump card is used" do
    before { card = Card.new(:hearts,1) }

    it {is_expected.to eq 14 }
  end

  context "when a jack, non-trump is used" do
    before { card = Card.new(:clubs, 11) }

    it {is_expected.to eq 11 }
  end

  context "when a trump card is used" do
    before {
      game_state.trump_suit = :hearts
      card = Card.new(:hearts, 9)
    }

    it { is_expected.to eq 109 }
  end

  context "when a right bower jack is used " do
    before {
      game_state.trump_suit = :hearts
      card = Card.new(:hearts, 11)
    }

    it { is_expected.to eq 116 }
  end

  context "when a left bower jack is used" do
    before {
      game_state.trump_suit = :hearts
      card = Card.new(:diamonds, 11)
    }

    it { is_expected.to eq 115 }
  end

  context "when a card following the leading suit is used" do
    before {
      game_state.pile.add( Card.new(:clubs, 9), nil )
      card = Card.new(:clubs, 10)
    }

    it { is_expected.to eq 60 }
  end

  context "when a card following the leading suit jack is used" do
    before {
      game_state.pile.add( Card.new(:clubs, 9), nil )
      card = Card.new(:clubs, 11)
    }

    it { is_expected.to eq 61 }
  end


end
