
class SortStack
  def initialize(game_state,stack)
    @stack = stack
    @game_state = game_state
  end

  def call
    @stack.sort {|x,y| compare(x, y)}
  end

  private

  def compare(x, y)
    card_value(y) <=> card_value(x)
  end

  def card_value(card)
    CalculateCardValue.new(@game_state, card).call
  end
end
