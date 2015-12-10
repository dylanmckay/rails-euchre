class Game < ActiveRecord::Base
  has_many :players, dependent: :destroy
  has_many :operations, through: :players
  belongs_to :initial_dealer, class_name: 'Player'
  def main_player
    players.first
  end

  def ai_players
    players[1..-1]
  end
end
