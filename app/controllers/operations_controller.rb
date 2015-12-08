class OperationsController < ApplicationController
  def new
    operation = Operation.create!(create_params)
    game = operation.game

    if operation.play_card?
      game_state = CreateGameState.new(game).call
      AI::DecideOperations.new(game, game_state).call
    end

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
