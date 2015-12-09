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

  def initialize(player_count, player_name=nil)
    @player_count = player_count
    @player_name = player_name
  end

  def call
    ai_count = @player_count - 1
    ai_count.times.map { create_ai }

    game = Game.create!(:players => players,
                        :initial_dealer_id => random_player(players).id,
                        :initial_trump => random_suit)

    game.with_lock do
      game.players.create!(:name => AI_NAMES.sample)
    end
  end

  private

  def player_name
    if @player_name.nil? || @player_name.strip.empty?
      AI_NAMES.sample
    else
      @player_name.capitalize
    end
  end

  def random_player(players)
    players.sample
  end

  def random_suit
    Card::SUITS.sample
  end
end
