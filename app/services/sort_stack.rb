class SortStack
  def initialize(game_state, stack)
    @stack = stack
    @game_state = game_state
  end

  def call
    @stack.sort { |x, y| compare_cards(x, y) }
  end

  private

  def compare_cards(x, y)
    card_value(y) <=> card_value(x)
  end

  def card_value(card)
    CalculateCardValue.new(@game_state, card).call
  end
end
