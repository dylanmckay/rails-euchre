class Card
  JACK = 11
  ACE = 1
  EUCHRE_CARD_RANGE = 9..13
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

  SUIT_NAMES = SUITS.map(&:to_s)

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
    rank == ACE
  end

  def jack?
    rank == JACK
  end

  def inspect
    to_s
  end
end
