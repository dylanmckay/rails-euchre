
class PlayerState

  attr_reader :id, :hand, :scored_cards

  def initialize(id, hand=[], scored_cards=[])
    @id = id
    @hand = hand
    @scored_cards = scored_cards
  end

  # TODO: improve name
  def add_won_cards(cards)
    @scored_cards += cards
  end

  def add_to_hand(card)
    card.player_id = @id
    @hand << card
  end

  def empty?
    @hand.empty?
  end
end
