class Game < ActiveRecord::Base
  has_many :players

  def operations
    Operation.where(:game == self).sort
  end

  def main_player
    players.first
  end

  def ai_players
    players[1..-1]
  end
end
