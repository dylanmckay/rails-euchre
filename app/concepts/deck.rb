class Deck
  DECK = Card::SUITS.flat_map do |suit|
    (1..13).select { |n| n >= 9 || n == 1 }
           .map { |n| Card.new(suit, n) }
  end
  def initialize
    refresh
  end

  def refresh
    @cards = DECK.map{|p| p }
    self
  end

  def pop(amount = 1)
    @cards.pop amount
  end

  def shuffle
    @cards.shuffle!
    self
  end
end
