class OperationsController < ApplicationController
  def create
    operation = Operation.create!(create_params)
    puts "SOMETHING #{create_params}"
    puts "HERE #{operation} AND ALSO #{operation.inspect}"
    p = Player.find(operation.player_id)
    puts "HERE IS PLAYER #{p}"
    redirect_to Player.last.game
  end

  def show
    operation = Operation.find(params[:operation_id])
    puts "THINGY #{operation.player}"
    redirect_to operation.player
  end

  private

  def create_params
    params.require(:operation).permit(:operation_type, :player_id, :suit, :rank)
  end
end
