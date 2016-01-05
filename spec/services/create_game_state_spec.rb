describe CreateGameState do
  context "when using a game model with two players" do

    let(:model) {
      game = Game.new

      p1 = game.players.new(id: 0, user: User.create!(name: "John"))
      game.players.new(id: 1, user: User.create!(name: "Jim"))
      game.initial_dealer = game.players.first

      p1.operations.deal_card.new(card: Card.new(:hearts, 1))

      game.save!
      game
    }

    subject(:state) { CreateGameState.new(model).call }

    it "creates a state with two players" do
      expect(state.players.length).to eq 2
    end

    it "sets the initial dealer" do
      expect(state.dealer.player).to eq model.players.first
    end
  end
end
