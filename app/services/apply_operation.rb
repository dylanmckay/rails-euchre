class ApplyOperation
  def initialize(game_state, operation)
    @game_state = game_state
    @operation = operation
    @player_state = @game_state.find_player(@operation.player)
  end

  def call
    send(@operation.type)
  end

  private

  def deal_card
    @player_state.hand << @operation.card
  end

  def pass_trump
    @game_state.trump_state.selection_operations << :pass
    @game_state.last_player = @player_state
  end

  def accept_trump
    @game_state.trump_state.selection_operations << :accept
    @game_state.trump_state.trump_selector = @operation.player
    trump_card = @game_state.trump_state.select_suit_as_trump
    @game_state.last_player = @player_state
    @game_state.dealer.hand << trump_card
  end

  def pick_trump
    @game_state.trump_state.selection_operations << :pick
    @game_state.trump_state.select_suit_as_trump @operation.suit.to_sym
    @game_state.last_player = @player_state
  end

  def draw_trump
    @game_state.trump_state.assign_new_selection_card(@operation.card)
  end

  def discard_card
    @player_state.hand.delete(@operation.card)
  end

  def play_card
    @game_state.pile.add(@player_state.hand.delete(@operation.card), @player_state)
    @game_state.last_player = @player_state

    FinishTrick.new(@game_state).call if every_player_has_played?
  end

  def every_player_has_played?
    @game_state.pile.length == @game_state.players.length
  end
end
