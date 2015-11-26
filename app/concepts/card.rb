
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
    "#{@value} of #{@suit.capitalize}"
  end

  def inspect
    to_s
  end
end
