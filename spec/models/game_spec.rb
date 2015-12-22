describe Game do
  let(:game) {
    g = Game.new

    g.players.new(user: User.create!(name: "Rob"))
    g.players.new(user: User.ai.create!(name: "Tim"))
    g.players.new(user: User.ai.create!(name: "Jim"))

    g.players.first.operations.pass_trump.new

    g.save!
    g
  }

  describe "#main_player" do
    subject { game.main_player.user }

    it { is_expected.to be_human }
  end

  describe "#ai_players" do
    it "returns only AI players" do
      game.ai_players.each do |player|
        expect(player.user).to be_ai
      end
    end
  end

  describe "#event_log" do
    it "should give back a list of strings" do
      game.event_log.each do |log_item|
        expect(log_item).to be_a String
      end
    end
  end
end
