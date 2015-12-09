
ACE_VALUE = 14
TRUMP_JACK_VALUE = 16

ADDITIONAL_TRUMP_POINTS = 100
ADDITIONAL_LEADING_SUIT_POINTS = 50

class CalculateCardValue
  def initialize(game_state, card)
    @game_state = game_state
    @card = card
  end

  def call
    card_value + additional_points
  end

  private

  def additional_points
    if @game_state.is_trump? @card
      ADDITIONAL_TRUMP_POINTS
    elsif @game_state.is_leading_suit? @card
      ADDITIONAL_LEADING_SUIT_POINTS
    else
      0
    end
  end

  def card_value
    if @card.jack? && @game_state.is_trump?(@card)
      trump_jack_value
    else
      @card.ace? ? ACE_VALUE : @card.rank
    end
  end

  def trump_jack_value
    if @card.suit == @game_state.trump_suit
      TRUMP_JACK_VALUE
    else
      TRUMP_JACK_VALUE - 1
    end
  end
end
