describe GamePresenter do
  let(:game) { create_game_model }
  let(:presenter) { GamePresenter.new(game) }

  describe "#hand_card_css_class" do
    context "when it's dynamic" do
      subject { presenter.hand_card_css_class(dynamic: true) }

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

  describe "#event_log" do
    before {
      user = User.new(name: "abc")
      player = game.players.new(user: user)
      game.operations.pass_trump.new(player: player)
      game.operations.accept_trump.new(player: player)
      game.operations.play_card.new(player: player, suit: :hearts, rank: 10)
      game.operations.discard_card.new(player: player)
    }

    subject { presenter.event_log }

    it { is_expected.to be_a String }
  end
end

