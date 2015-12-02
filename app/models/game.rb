require_relative '../concepts/game_state'
require_relative '../concepts/player_state'
require_relative '../services/apply_operation'

class Game < ActiveRecord::Base
  has_many :players

  before_create :setup_state

  def operations
    # TODO: optimize
    # We must sort the operations by ID so that they are
    # in chronological order, otherwise the game will break.
    players.all
           .flat_map { |player| player.operations }
           .sort_by { |operation| operation.id }
  end

  private

  def setup_state
    @game = GameState.new(initial_player_states)

    # Apply the operations
    operations.each { |operation| ApplyOperation.new(self).call(operation) }
  end

  def initial_player_states
    players.all.map { |player| PlayerState.new(player.id) }
  end
end

