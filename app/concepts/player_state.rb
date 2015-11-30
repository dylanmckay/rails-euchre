
class PlayerState

  attr_reader :id, :name
  attr_accessor :hand, :scored_cards

  def initialize(id:, name:, hand: [], scored_cards: [])
    @id = id
    @name = name
    @hand = hand
    @scored_cards = scored_cards
  end

  def has_card?(card)
    @hand.include?(card) || @scored_cards.include?(card)
  end
end
