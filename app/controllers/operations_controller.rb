class OperationsController < ApplicationController
  def create
    operation = Operation.create!(create_params)
    redirect_to operation.player.game
  end

  def show
    operation = Operation.find(params[:operation_id])
    redirect_to operation.player.game
  end

  private

  def create_params
    params.require(:operation).permit(:operation_type, :suit, :rank)
  end
end
