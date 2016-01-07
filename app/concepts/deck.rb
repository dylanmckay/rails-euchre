class Deck
  attr_reader :cards

  CARD_RANGE = 1..13
  EUCHRE_CARD_MIN = 9
  
  DECK = Card::SUITS.flat_map do |suit|
    (CARD_RANGE).select { |n| n >= EUCHRE_CARD_MIN || n == Card::ACE }
           .map { |n| Card.new(suit, n) }
  end

  delegate :pop, :shuffle!, to: :cards

  def initialize
    @cards = DECK.dup
  end

  def refresh
    @cards = DECK.dup
    self
  end
end
