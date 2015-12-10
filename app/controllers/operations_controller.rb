class OperationsController < ApplicationController
  def new
    player = Player.find(params[:player_id])

    game = player.game.with_lock do
      operation = player.operations.create!(operation_params)

      game = operation.game
      AdvanceGame.new(game).call
      game
    end

    redirect_to game
  end

  def show
    operation = Operation.find(params[:operation_id])
    redirect_to operation.player
  end

  private

  def operation_params
    params.permit(:operation_type, :suit, :rank)
  end
end
