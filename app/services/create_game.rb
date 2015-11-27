
NAMES = [
  'Bill',
  'John',
  'Sally',
  'Andy',
  'Joseph',
]

class CreateGame
  def call(player_count)
    game = Game.create!

    player_count.times do
      game.players.create!(:name => NAMES.sample)
    end

    game
  end
end
