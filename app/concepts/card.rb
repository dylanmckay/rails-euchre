
class Card
  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def ==(other)
    if other.is_a?(Card)
      @suit == other.suit &&
      @value == other.value
    else
      false
    end
  end

  def to_s
    "(#{suit}, #{value})"
  end

  def inspect
    "(#{suit}, #{value})"
  end
end
