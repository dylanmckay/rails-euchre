class CreateGame
  def initialize(player_count:, user:)
    @player_count = player_count
    @user = user
  end

  def call
    Game.create!.tap do |game|
      game.with_lock do
        build_human_player(game)
        ai_count.times { build_ai_player(game) }

        game.initial_dealer = random_player(game.players)
        game.save!
      end
    end
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
end
