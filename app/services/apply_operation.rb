
class ApplyOperation
  def initialize(game_state, operation)
    @game_state = game_state
    @operation = operation
    @player = @game_state.find_player(@operation.player_id)
  end

  def call
    send(@operation.type)
  end

  private

  def deal_card
    @player.hand << @operation.card
  end

  def pass_trump
    @game_state.trump_state.selection_operations << :pass
    @game_state.last_player = @player
  end

  def accept_trump
    @game_state.trump_state.selection_operations << :accept
    @game_state.trump_state.select_suit_as_trump
    @game_state.last_player = @player
  end

  def pick_trump
    @game_state.trump_state.selection_operations << :pick
    @game_state.trump_state.suit = @operation.suit.to_sym
    @game_state.last_player = @player
  end

  def finish_trick
    winner = @game_state.trick_leader
    winner.scored_cards += @game_state.pile.cards
    @game_state.pile.clear
    @game_state.trick_winners << winner

    finish_round if every_player_has_no_cards?
  end

  def play_card
    @game_state.pile.add(@player.hand.delete(@operation.card), @player)
    @game_state.last_player = @player

    finish_trick if every_player_has_played?
  end

  def finish_round
    @game_state.round_winners << @game_state.round_leader

    @game_state.players.each do |player|
      player.total_score += @game_state.calculate_points(player)
      player.scored_cards.clear
    end
    @game_state.trick_winners = []
    assign_next_dealer
  end

  def assign_next_dealer
    index = current_dealer_index

    # get the next player, wrapping the index back to the start
    next_index = (index+1) % @game_state.players.length

    @game_state.dealer = @game_state.players[next_index]
  end

  def current_dealer_index
    @game_state.players.find_index do |player|
      player == @game_state.dealer
    end
  end

  def every_player_has_played?
    @game_state.pile.length == @game_state.players.length
  end

  def every_player_has_no_cards?
    @game_state.players.map(&:hand).all?(&:empty?)
  end
end
