class OperationsController < ApplicationController
  def new
    player = Player.find(params[:player_id])

    game = player.game.with_lock do
      operation = player.operations.create!(operation_params)

      game = operation.player.game
      AdvanceGame.new(game).call
      game
    end

    redirect_to game
  end

  private

  def operation_params
    params.permit(:operation_type, :suit, :rank)
  end
end
