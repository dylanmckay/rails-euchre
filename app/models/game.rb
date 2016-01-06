class Game < ActiveRecord::Base
  has_many :players, dependent: :destroy
  has_many :operations, through: :players
  belongs_to :initial_dealer, class_name: 'Player'

  validates :initial_dealer, null: false

  def main_player
    players.find{ |p| p.user.human? }
  end

  def ai_players
    players.select { |player| player.user.ai? }
  end
end
