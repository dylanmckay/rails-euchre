class Game < ActiveRecord::Base
  has_many :players
  has_many :operations, through: :players

  before_create :setup_state

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

