class GamesController < ApplicationController

  def new; end

  def show
    @game = Game.find(params[:id])
  end

  def index; end

  def create
    game = Game.create!
    redirect_to game
  end
end
