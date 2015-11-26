
class GameState

  attr_reader :players
  attr_accessor :trump_suit, :pile

  def initialize(players)
    @trump_suit = nil
    @pile = []
    @players = players
  end

  def find_player(id)
    @players.find { |player| player.id == id }
  end
end
