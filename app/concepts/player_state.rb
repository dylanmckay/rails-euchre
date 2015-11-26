
class PlayerState

  attr_reader :id
  attr_accessor :hand

  def initialize(id, hand)
    @id = id
    @hand = hand
  end

  def empty?
    @hand.empty?
  end
end
