class ActionsController < ApplicationController
  def create
    action = Action.create!(create_params)
    redirect_to action.player.game
  end

  def show
    action = Action.find(params[:action_id])
    redirect_to action.player.game
  end

  private

  def create_params
    params.require(:action).permit(:action_type, :suit, :rank)
  end
end
