
class Card
  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def ==(other)
    @suit == other.suit
    @value == other.value
  end

  def to_s
    "(#{suit}, #{value})"
  end

  def inspect
    "(#{suit}, #{value})"
  end
end
