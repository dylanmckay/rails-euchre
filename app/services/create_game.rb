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
    game = Game.create!(initial_trump: random_suit)

    # TODO: This is ugly, fix it.
    #
    # We need to store a player ID inside the game, but players
    # are not assigned IDs until they are saved. The players
    # cannot be saved until the game itself is saved.
    #
    # It would be nice to have a `null: false` validation for
    # `initial_dealer` but it introduces this cyclic dependence.
    game.with_lock do
      build_human_player(game)
      ai_count.times { build_ai_player(game) }

      game.initial_dealer = random_player(game.players)
      game.save!
    end

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

  def build_ai_player(game)
    game.players.create!(name: AI_NAMES.sample)
  end

  def build_human_player(game)
    game.players.create!(name: player_name)
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
