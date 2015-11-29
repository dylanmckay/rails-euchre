require_relative '../services/create_game'
class GamesController < ApplicationController

  def new; end

  def show
    @game = Game.find(params[:id])
  end

  def index; end

  def create
    game = CreateGame.new.call(params[:player_number].to_i)
    redirect_to game
  end
end
