class Game < ActiveRecord::Base
  has_many :players

  def operations
    #FIXME: rails queries rather than ruby sorting
    #       this is really hurting performance
    Operation.all.select { |op| op.player.game.id == id }.sort
  end

  def main_player
    players.first
  end

  def ai_players
    players[1..-1]
  end
end
