
class Card
  attr_reader :suit, :rank

  PARTNER_SUITS = {
    :hearts   => :diamonds,
    :diamonds => :hearts,
    :spades   => :clubs,
    :clubs    => :spades
  }

  def initialize(suit, rank)
    @suit = suit.to_sym
    @rank = rank
  end

  def ==(other)
    other.is_a?(Card) &&
      suit == other.suit &&
      rank == other.rank
  end

  def <=>(other)
    other.rank - rank
  end

  def <(other)
    puts "#{other.rank - rank}"
    rank - other.rank
  end

  def >(other)
    puts "#{rank - other.rank}"
    rank - other.rank
  end

  def partner_suit
    PARTNER_SUITS.fetch(suit)
  end

  def to_s
    "#{rank} of #{suit.to_s.capitalize}"
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
