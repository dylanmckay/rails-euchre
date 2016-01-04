describe Game do
  let(:game) {
    g = Game.new

    g.players.new(user: User.create!(name: "Rob"))
    g.players.new(user: User.ai.create!(name: "Tim"))
    g.players.new(user: User.ai.create!(name: "Jim"))

    g.players[0].operations.deal_card.new(suit: "diamonds", rank: 13)
    g.players[0].operations.deal_card.new(suit: "hearts", rank: 9)
    g.players[1].operations.deal_card.new(suit: "hearts", rank: 10)
    g.players[2].operations.deal_card.new(suit: "hearts", rank: 11)

    g.players[0].operations.pass_trump.new
    g.players[1].operations.pick_trump.new(suit: "diamonds", rank: 6)
    g.players[2].operations.discard_card.new(suit: "hearts", rank: 11)
    g.main_player.operations.deal_card.new(suit: "diamonds", rank: 14)

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

  xdescribe "#event_log" do
    it "should give back a list of strings" do
      game.event_log.each do |log_item|
        expect(log_item).to be_a String
      end
    end
  end
end
