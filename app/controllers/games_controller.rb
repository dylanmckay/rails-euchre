require_relative '../services/create_game'
require_relative '../services/create_game_state'

class GamesController < ApplicationController

  def create
    user = User.find(params[:user_id])

    game = CreateGame.new(
      params[:player_number].to_i,
      user,
    ).call
    DealCards.new(game).call
    redirect_to game
  end

  def show
    game = Game.find(params[:id])
    @game = GamePresenter.new(game, view_context)
    @game_state = CreateGameState.new(@game).call
  end

  def index; end
end
