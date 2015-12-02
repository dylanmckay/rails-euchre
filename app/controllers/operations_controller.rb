class OperationsController < ApplicationController
  def create
    operation = Operation.create!(create_params)
    p = Player.find(operation.player_id)
    redirect_to Player.last.game
  end

  def new
    operation = Operation.create!(create_params)
    p = Player.find(operation.player_id)
    redirect_to Player.last.game
  end

  def show
    operation = Operation.find(params[:operation_id])
    redirect_to operation.player
  end

  private

  def create_params
    params.permit(:operation_type, :player_id, :suit, :rank)
  end
end
