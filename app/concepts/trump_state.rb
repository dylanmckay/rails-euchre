class TrumpState
  attr_accessor :selection_operations, :suit, :selection_card

  def initialize(game_state, deck)
    @game_state = game_state
    @deck = deck
    @suit = nil
    @selection_operations = []
  end

  def pop_new_trump_card
    @suit = nil
    card = @deck.pop.first
    @selection_card = card
    card
  end

  def selection_suit
    @selection_card.nil? ? nil : @selection_card.suit
  end

  def assign_new_selection_card(card)
    @selection_card = card
    @suit = nil
  end

  def select_suit_as_trump(new_suit = selection_suit)
    @suit = new_suit
    card = @selection_card
    @selection_card = nil
    card
  end

  def selected?
    !@suit.nil?
  end

  def pick_phase?
    @selection_operations.select { |op| op == :pass }.size == @game_state.players.size
  end
end
