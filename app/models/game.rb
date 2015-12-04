class Game < ActiveRecord::Base
  has_many :players
  #has_many :operations, through: :players
  #FIXME: rails queries rather than ruby sorting
  def operations
    Operation.all.select { |op| op.player.game.id == id }.sort
  end

  private

  def initial_player_states
    players.all.map { |player| PlayerState.new(player.id) }
  end
end
