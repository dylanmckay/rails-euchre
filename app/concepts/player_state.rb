
class PlayerState
  attr_reader :player
  attr_accessor :hand, :scored_cards,  :total_score

  def initialize(player:, hand: [], scored_cards: [])
    @player = player
    @hand = hand
    @scored_cards = scored_cards
    @total_score = 0
  end

  def has_card?(card)
    @hand.include?(card) || @scored_cards.include?(card)
  end
end
