describe AdvanceGame do
  let(:players) {
    create_player_models(2)
  }

  let(:game) {
    create_game_model(
      players: players
    )
  }

  context "at the start of trump selection" do
    before {
      state = CreateGameState.new(game).call
      DealCards.new(game, game_state: state).call
    }

    it "should deal everybody cards" do
      expect_any_instance_of(DealCards).to receive(:call).and_call_original
      AdvanceGame.new(game).call
    end
  end
end
