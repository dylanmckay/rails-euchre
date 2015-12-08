
class SortStack
  def initialize(game_state,stack)
    @stack = stack
    @game_state = game_state
  end

  def call
    @stack.sort {|x,y| compare_cards(x, y)}
  end

  private

  def compare_cards(x, y)
    CompareCards.new(@game_state,x,y).call
  end
end
