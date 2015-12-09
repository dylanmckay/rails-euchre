
class CompareCards
  def initialize(game_state, card_a, card_b)
    @game_state = game_state
    @card_a = card_a
    @card_b = card_b
  end

  def call
    card_value(@card_b) <=> card_value(@card_a)
  end

  private

  def card_value(card)
    CalculateCardValue.new(@game_state, card).call
  end
end
