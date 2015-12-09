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

  def initialize(player_count, player_name = nil)
    @player_count = player_count
    @player_name = player_name
  end

  def call
    game = Game.new(initial_trump: random_suit)

    game.with_lock do
      build_human_player(game)
      ai_count.times { build_ai_player(game) }

      pl = random_player(game.players)
      puts pl.to_s

      game.initial_dealer_id = pl.id
      game.save!
      game.players.each(&:save!)
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

  def build_ai_player(game)
    game.players.new(name: AI_NAMES.sample)
  end

  def build_human_player(game)
    game.players.new(name: player_name)
  end

  def ai_count
    @player_count - 1
  end

  def random_player(players)
    players.sample
  end

  def random_suit
    Card::SUITS.sample
  end
end
