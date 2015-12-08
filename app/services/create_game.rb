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

    Game.transaction do

      players = [ Player.create!(:name => player_name) ]

      ai_count = @player_count - 1
      players += ai_count.times.map do
        Player.create!(:name => AI_NAMES.sample)
      end

      Game.create!(:players => players,
                   :initial_dealer_id => random_player(players).id,
                   :initial_trump => random_suit)
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
