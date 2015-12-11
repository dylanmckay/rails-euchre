describe AdvanceGame do

  context "at the start of trump selection" do
    let(:players) {
      create_player_models(2)
    }

    let(:game) {
      create_game_model(
        players: players,
      )
    }

    it "should deal everybody cards" do
      expect_any_instance_of(DealCards).to receive(:call).and_call_original
      AdvanceGame.new(game).call
    end

  end
end
