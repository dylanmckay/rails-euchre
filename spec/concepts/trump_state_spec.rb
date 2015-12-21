describe TrumpState do
  context "at the start of a game" do
    let(:state) { TrumpState.new(game, deck) }
    let(:deck) { Deck.new }

    let(:players) {[
        PlayerState.new(id: 5, hand: create_hand, name: "Henry"),
        PlayerState.new(id: 10, name: "Harold"),
    ]}

    subject(:game) {
      create_game(
        players: players,
        dealer: players.sample,
        trump: :hearts,
      )
    }

    describe "#selection_suit" do
      it "is should be nil" do
        expect(state.selection_suit).to eq nil
      end
    end

    describe "#pick_phase?" do
      it "should not be in the pick phase" do
        expect(state.pick_phase?).to eq false
      end
    end
  end
end
