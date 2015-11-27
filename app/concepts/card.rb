
class Card
  include Comparable
  attr_reader :suit, :rank
  attr_accessor :player_id

  PARTNER_SUITS = {
    :hearts   => :diamonds,
    :diamonds => :hearts,
    :spades   => :clubs,
    :clubs    => :spades
  }

  def initialize(suit, rank, player_id=nil)
    @suit = suit.to_sym
    @rank = rank
    @player_id = player_id
  end

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
