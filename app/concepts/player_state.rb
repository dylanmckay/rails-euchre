
class PlayerState

  attr_reader :id
  attr_accessor :hand, :scored_cards

  def initialize(id:, hand: [], scored_cards: [])
    @id = id
    @hand = hand
    @scored_cards = scored_cards
  end

  def has_card?(card)
    @hand.include?(card) || @scored_cards.include?(card)
  end
end
