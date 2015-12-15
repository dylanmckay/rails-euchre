class Game < ActiveRecord::Base
  has_many :players, dependent: :destroy
  has_many :operations, through: :players
  belongs_to :initial_dealer, class_name: 'Player'
  EVENT_LOG_ENTRIES = 4

  def main_player
    players.find{ |p| p.user.human? }
  end

  def ai_players
    players.select { |player| player.user.ai? }
  end

  #TODO: Put in presenter or something of the like
  def event_log
    operations.last(EVENT_LOG_ENTRIES).map {|op| op.description}
  end
end
