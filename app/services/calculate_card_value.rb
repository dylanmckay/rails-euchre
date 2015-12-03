
class CalculateCardValue
  def initialize(game_state,card)
    @game_state = game_state
    @card = card
  end

  def call
    card_value + additional_points
  end

  private

  def additional_points
    if @game_state.is_trump? @card
      100
    elsif @game_state.is_leading_suit? @card
      50
    else
      0
    end
  end

  def card_value
    if @card.jack? && @game_state.is_trump?(@card)
      trump_card_value = 16
      trump_card_value -=1 if @card.suit != @game_state.trump_suit
      trump_card_value
    else
      @card.ace? ? 14 : @card.rank
    end
  end
end
