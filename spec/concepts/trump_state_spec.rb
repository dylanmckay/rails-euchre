describe TrumpState do
  context "at the start of a game" do
    let(:state) { TrumpState.new(game, deck) }
    let(:deck) { Deck.new }
    let(:player_models) { create_player_models(2) }
    let(:players) {[
        PlayerState.new(player: player_models[0], hand: create_hand),
        PlayerState.new(player: player_models[1])
    ]}

    subject(:game) {
      create_game(
        players: players,
        dealer: players.sample,
        trump: :hearts,
      )
    }

    describe "#pick_phase?" do
      it "is not in the pick phase" do
        expect(state).to_not be_pick_phase
      end
    end
  end
end
