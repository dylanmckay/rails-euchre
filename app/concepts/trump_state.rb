class TrumpState
  attr_accessor :selection_operations, :suit, :selection_card, :trump_selector

  def initialize(deck, number_of_players)
    @number_of_players = number_of_players
    @deck = deck
    @suit = nil
    @selection_operations = []
    @trump_selector = nil
    @thing = false
  end

  def pop_new_trump_card
    @suit = nil
    card = @deck.pop
    @selection_card = card
  end

  def selection_suit
    selected? && @selection_card.suit ? nil : @selection_card.suit
  end

  def assign_new_selection_card(card)
    @selection_card = card
    @thing = false
  end

  def select_suit_as_trump(new_suit = selection_suit)
    @suit = new_suit
    card = @selection_card
    @thing = true
    card
  end

  def selected?
    @thing
  end

  def pick_phase?
    @selection_operations.select { |op| op == :pass }.size == @number_of_players
  end
end
