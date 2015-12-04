describe Pile do

  let(:player) {
    PlayerState.new(id: 0, name: "Tana")
  }

  let(:pile) {
    pile = Pile.new
    pile.add(Card.new(:hearts, 8), player)
    pile.add(Card.new(:hearts, 9), player)
    pile
  }

  describe "#add" do
    context "adding a single card" do
      subject { -> {
        pile.add(Card.new(:clubs, 12), player)
      }}

      it { is_expected.to change { pile.length }.by 1 }
    end
  end

  describe "#clear" do
    subject { -> { pile.clear } }

    it { is_expected.to change { pile.length }.to 0 }
  end

  describe "#card_owner" do
    context "when the pile is empty" do
      let(:pile) { Pile.new }

      subject { -> {
        pile.card_owner(Card.new(:hearts, 8))
      }}

      it { is_expected.to raise_error Exception }
    end

    context "when the card exists in the pile" do
      subject {
        pile.card_owner(Card.new(:hearts, 8))
      }

      it { is_expected.to be_a PlayerState }
    end

    context "when the card does not exist" do
      subject {
        pile.card_owner(Card.new(:spades, 13))
      }

      it { is_expected.to eq nil }
    end
  end

end
