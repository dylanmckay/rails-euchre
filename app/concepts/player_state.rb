
class PlayerState

  attr_reader :id, :name
  attr_accessor :hand, :scored_cards
  attr_accessor :total_score

  def initialize(id:, name:, hand: [], scored_cards: [], ai: false)
    @id = id
    @name = name
    @hand = hand
    @scored_cards = scored_cards
    @total_score = 0
    @ai = ai
  end

  def ai?; @ai; end
  def human?; !@ai; end

  def has_card?(card)
    @hand.include?(card) || @scored_cards.include?(card)
  end
end
