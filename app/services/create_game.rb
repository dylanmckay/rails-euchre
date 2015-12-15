class CreateGame
  def initialize(player_count:, user:)
    @player_count = player_count
    @user = user
  end

  def call
    game = Game.create!

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

  def find_ai_user
    User.ai.sample
  end

  def build_ai_player(game)
    user = find_ai_user
    game.players.create!(user: user)
  end

  def build_human_player(game)
    game.players.create!(user: @user)
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
