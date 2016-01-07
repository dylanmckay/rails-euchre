class GamesController < ApplicationController
  def create
    user = User.find(params[:user_id])

    game = CreateGame.new(
      player_count: params[:player_number].to_i,
      user: user,
    ).call

    AdvanceGame.new(game).call
    redirect_to game
  end

  def show
    game = Game.find(params[:id])
    @game_state = CreateGameState.new(game).call
    @game = GamePresenter.new(game, @game_state)
    @user = @game.main_player.user
  end
end
