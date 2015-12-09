class OperationsController < ApplicationController
  def new
    operation = Operation.create!(create_params)
    game = operation.game
    puts "STARTED OPERATION "
    AdvanceGame.new(game).call
    puts "ENDED OPERATION AND REDIRECTING"
    redirect_to game
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
