class CreateGame
  AI_NAMES = [
    'Bill',
    'John',
    'Sally',
    'Andy',
    'Joseph',
    "Tony",
    "Jim",
    "Ella",
    "Amy",
    "Eric",
  ]

  def initialize(player_count)
    @player_count = player_count
  end

  def call

    players = @player_count.times.map do
      Player.create!(:name => AI_NAMES.sample)
    end

    game = Game.create!(:players => players,
                        :initial_dealer_id => choose_dealer(players).id)

    game
  end

  private

  def choose_dealer(players)
    players.sample
  end
end
