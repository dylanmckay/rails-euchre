require_relative '../../app/services/create_game'

describe CreateGame do

  it "creates a game object" do
    expect(CreateGame.new.call(2)).to be_a Game
  end

  it "creates four players when you ask it to" do
    expect(CreateGame.new.call(4).players.size).to eq 4
  end
end
