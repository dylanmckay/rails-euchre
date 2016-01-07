
class Pile
  attr_reader :placed_cards
  delegate :length, :clear, :empty?, :any?, :clear, :pop, to: :placed_cards

  PlacedCard = Struct.new(:card, :player)

  def initialize
    @placed_cards = []
  end

  def add(card, player)
    raise "Cannot add nil" if card == nil
    @placed_cards << PlacedCard.new(card, player)
  end

  def cards
    @placed_cards.each.map { |info| info.card }
  end

  def leading_card
    if @placed_cards.present?
      @placed_cards.first.card
    end
  end

  def card_owner(card)
    raise Exception, 'the pile is empty' if empty?

    info = @placed_cards.each.find { |placed_card| placed_card.card == card }

    info.player if info
  end
end
