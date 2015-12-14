class TrumpState
  attr_accessor :selection_operations, :suit, :selection_suit

  def initialize(players, initial_player, selection_suit, deck)
    @players = players
    @initial_dealer = initial_player
    @deck = deck
    @suit = nil
    @selection_suit = selection_suit
    @selection_operations = []
  end

  def next_player_selection
    initial_player_index = @players.find { |p| p==@initial_player }
    next_player_index = initial_player_index + @selection_operations.length
    @players[next_player_index % @players.length]
  end

  def restart_selection
    if @suit
      @selection_suit = @deck.pop.first.suit
      @suit = nil
    end
  end

  def select_suit_as_trump
    @suit = @selection_suit
    @selection_suit = nil
  end

  def selected?
    !@suit.nil?
  end
end
