class OperationsController < ApplicationController
  def new
    operation = Operation.create!(operation_params)
    game = operation.game
    AdvanceGame.new(game).call
    redirect_to game
  end

  def show
    operation = Operation.find(params[:operation_id])
    redirect_to operation.player
  end

  private

  def operation_params
    params.permit(:operation_type, :player_id, :suit, :rank)
  end
end
