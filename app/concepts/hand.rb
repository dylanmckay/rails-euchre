
class Hand

  attr_reader :player_id
  attr_accessor :cards

  def initialize(player_id, cards)
    @player_id = player_id
    @cards = cards
  end

  def empty?
    @cards.empty?
  end
end
