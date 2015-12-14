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


  def restart_selection
    print "Restart selection? "
    if @suit
      print " YES! "
      @next_trump_card = @deck.pop.first
      # game_state.player.
      @suit = nil
    end
    puts ""
  end

  def selection_suit
    #TODO REFACTOR THIS
    @selection_card == nil ? nil : @selection_card.suit
  end

  def assign_new_selection_card(card)
    @selection_card = card
    @suit = nil
  end

  def select_suit_as_trump(new_suit = selection_suit)
    print "seectin new trump ?? "
    # if !@suit
      print "  YESSS"
      @suit = new_suit
      @selection_card = nil
    # end
    puts
  end

  def selected?
    !@suit.nil?
  end
end
