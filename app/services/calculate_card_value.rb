class CalculateCardValue
  ACE_VALUE = 14
  RIGHT_BOWER_VALUE = 16
  LEFT_BOWER_VALUE = 15

  ADDITIONAL_TRUMP_POINTS = 100
  ADDITIONAL_LEADING_SUIT_POINTS = 50

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
    elsif @game_state.leading_suit == @card.suit
      ADDITIONAL_LEADING_SUIT_POINTS
    else
      0
    end
  end

  def card_value
    if @card.jack? && @game_state.is_trump?(@card)
      trump_jack_value
    elsif @card.ace?
      ACE_VALUE
    else
      @card.rank
    end
  end

  def trump_jack_value
    trump_card? ? RIGHT_BOWER_VALUE : LEFT_BOWER_VALUE
  end

  def trump_card?
    @card.suit == @game_state.trump_suit
  end
end
