require_relative '../concepts/game_state'
require_relative '../concepts/player_state'
require_relative '../services/apply_action'

class Game < ActiveRecord::Base
  has_many :players

  after_initialize :setup_state

  def actions
    # TODO: optimize
    players.all
           .flat_map { |player| player.actions }
           .sort_by { |action| action.id }
  end

  private

  def setup_state
    @game = Game.new(initial_player_states)

    # Apply the actions
    actions.each { |action| ApplyAction.new(self).call(action) }
  end

  def initial_player_states
    players.all.map { |player| PlayerState.new(player.id) }
  end
end

