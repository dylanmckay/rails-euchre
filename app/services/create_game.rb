class CreateGame
  AI_NAMES = [
    'Bill',
    'John',
    'Sally',
    'Andy',
    'Joseph',
  ]

  def initialize(player_count)
    @player_count = player_count
  end

  def call
    game = Game.create!

    @player_count.times do
      game.players.create!(:name => AI_NAMES.sample)
    end

    DealCards.new(game).call

    game
  end
end
