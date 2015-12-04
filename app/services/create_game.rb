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

    players = [ Player.create!(:name => player_name) ]

    ai_count = @player_count - 1
    players += ai_count.times.map do
      Player.create!(:name => AI_NAMES.sample)
    end

    game = Game.create!(:players => players,
                        :initial_dealer_id => choose_dealer(players).id)

    game
  end

  private

  def player_name
    if @player_name.nil? || @player_name.strip.empty?
      AI_NAMES.sample
    else
      @player_name.capitalize
    end
  end

  def choose_dealer(players)
    players.sample
  end
end
