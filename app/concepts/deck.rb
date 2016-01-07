class Deck
  attr_reader :cards
  #TODO magic numbers
  DECK = Card::SUITS.flat_map do |suit|
    (1..13).select { |n| n >= 9 || n == 1 }
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
