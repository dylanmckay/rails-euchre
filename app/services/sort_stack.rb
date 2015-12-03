
class SortStack
  def initialize(game_state,stack)
    @stack = stack
    @game_state = game_state
  end

  def call
    @stack.sort {|x,y| CalculateCardValue.new(@game_state, y).call <=> CalculateCardValue.new(@game_state, x).call}
  end
end
