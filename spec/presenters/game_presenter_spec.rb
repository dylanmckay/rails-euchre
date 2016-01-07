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

  describe "#event_log" do
    before {
      player = game.players.first

      player.operations.draw_trump.create!( card: Card.new(:spades, 1) )
      player.operations.pass_trump.create!
      player.operations.accept_trump.create!
      player.operations.discard_card.create!(card: Card.new(:hearts, 10))
      player.operations.play_card.create!(card: Card.new(:spades, 1))
    }

    subject { presenter.event_log }

    it { is_expected.to be_a String }
  end
end
