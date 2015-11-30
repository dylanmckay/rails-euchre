require_relative '../../app/services/create_game_state'

describe CreateGameState do
  context "when using a game model with two players" do

    let(:model) {
      Game.create!(players: [
        Player.create!(id: 0, name: "Rob"),
        Player.create!(id: 1, name: "Jim"),
      ])
    }

    subject(:state) { CreateGameState.new.call(model) }

    it "creates a state with two players" do
      expect(state.players.length).to eq 2
    end
  end
end
