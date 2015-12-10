require_relative '../services/create_game'
require_relative '../services/create_game_state'

class GamesController < ApplicationController

  def new; end

  def show
    @game = Game.find(params[:id])
    @game_state = CreateGameState.new(@game).call
    if !@game_state.round_in_progress?
      DealCards.new(@game_model, @game_state).call
    end
  end

  def index; end

  def create
    game = CreateGame.new(
      params[:player_number].to_i,
      params[:player_name]
    ).call
    CreateGameState.new(game).call
    redirect_to game
  end
end
