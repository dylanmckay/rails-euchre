
class GameState

  attr_reader :hands
  attr_accessor :trump_suit, :pile

  def initialize(hands)
    @trump_suit = nil
    @pile = []
    @hands = hands
  end

  def find_hand(player_id)
    @hands.find { |hand| hand.player_id == player_id }
  end

  def in_progress?
    @hands.each.none?(&:empty)
  end
end
