describe GamePresenter do
  let(:game) { create_game_model }
  let(:state) { CreateGameState.new(game).call }
  let(:presenter) { GamePresenter.new(game, state) }

  describe "#card_css_class" do
    context "when it's dynamic" do
      subject { presenter.card_css_class(interactive: true) }

      it { is_expected.to be_a String }
    end
  end

  describe "#unicode_suit" do
    subject { presenter.unicode_suit(:hearts) }

    it { is_expected.to be_a String }
  end

  describe "#unicode_card_back" do
    subject { presenter.unicode_card_back }

    it { is_expected.to be_a String }
  end

  xdescribe "#event_log" do
    before {
      player = game.players.first

      game.operations.pass_trump.new(player: player)
      game.operations.accept_trump.new(player: player)
      game.operations.play_card.new(player: player, suit: :hearts, rank: 10)
      game.operations.discard_card.new(player: player)
    }

    subject { presenter.event_log }

    it { is_expected.to be_a String }
  end
end

