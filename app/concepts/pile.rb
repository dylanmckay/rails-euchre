
class Pile
  attr_reader :placed_cards
  delegate :length, :clear, :empty?, :any?, :clear, to: :placed_cards

  # Internal helper class to store card and player
  PlacedCard = Struct.new(:card, :player)

  def initialize
    @placed_cards = []
  end

  def add(card, player)
    raise "Cannot add a nil card" if card == nil
    @placed_cards << PlacedCard.new(card, player)
  end

  def length
    @placed_cards.length
  end

  def cards
    @placed_cards.each.map { |info| info.card }
  end

  def leading_card
    if @placed_cards.empty?
      nil
    else
      @placed_cards.first.card
    end
  end

  def card_owner(card)
    raise Exception, 'the pile is empty' if empty?

    info = @placed_cards.each.find { |i| i.card == card }

    info.player if info
  end
end
