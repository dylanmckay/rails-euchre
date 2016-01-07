class TrumpState
  attr_accessor :selection_operations, :suit, :selection_card, :trump_chooser

  def initialize(deck, number_of_players)
    @number_of_players = number_of_players
    @deck = deck
    @suit = nil
    @selection_operations = []
    @trump_chooser = nil
    @selected = false
  end

  def pop_new_trump_card
    @selected = false
    @selection_card = @deck.pop
  end

  def selection_suit
    @selection_card.suit
  end

  def assign_new_selection_card(card)
    @selection_card = card
    @selected = false
  end

  def select_suit_as_trump(new_suit = selection_suit)
    @suit = new_suit
    @selected = true
    @selection_card
  end

  def trump_selected?
    @selected
  end

  def pick_phase?
    @selection_operations.select { |op| op == :pass }.size == @number_of_players
  end
end
