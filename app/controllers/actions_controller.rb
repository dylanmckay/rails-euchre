class ActionsController < ApplicationController
  def create
    action = Action.create!(create_params)
    redirect_to action.player.game
  end

  def show
    game = Game.find(params[:game_id])
    redirect_to game
  end

  private

  def create_params
    params.require(:action).permit(:action_type, :suit, :rank)
  end
end
