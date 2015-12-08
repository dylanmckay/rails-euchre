class TrumpState
  attr_reader :suit
  attr_accessor :selection_operations, :suit, :selection_suit

  def initialize(players, initial_player, selection_suit)
    @players = players
    @initial_dealer = initial_player
    @suit = nil
    @selection_suit = selection_suit
    @selection_operations = []
  end

  def next_player_selection
    initial_player_index = @players.find { |p| p==@initial_player }
    next_player_index = initial_player_index + @selection_operations.length
    @players[next_player_index % @players.length]
  end

  def selected?
    !@suit.nil?
  end
end
