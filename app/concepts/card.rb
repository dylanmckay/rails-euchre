
class Card
  include Comparable
  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit.to_sym
    @rank = rank
  end

  SUITS = [
    :hearts,
    :diamonds,
    :spades,
    :clubs,
  ]

  DECK = SUITS.flat_map do |suit|
    (1..13).select { |n| n >= 9 || n == 1 }
           .map { |n| Card.new(suit, n) }
  end

  PARTNER_SUITS = {
    :hearts   => :diamonds,
    :diamonds => :hearts,
    :spades   => :clubs,
    :clubs    => :spades
  }

  def ==(other)
    other.is_a?(Card) &&
      suit == other.suit &&
      rank == other.rank
  end

  def <=>(other)
    rank <=> other.rank
  end

  def partner_suit
    PARTNER_SUITS.fetch(suit)
  end

  def to_s
    "(#{rank} of #{suit.to_s.capitalize})"
  end

  def ace?
    rank == 1
  end

  def jack?
    rank == 11
  end

  def inspect
    to_s
  end
end
