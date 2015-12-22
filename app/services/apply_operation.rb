
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
    trump_card = @game_state.trump_state.select_suit_as_trump
    @game_state.last_player = @player_state
    puts "TRUMP CARD IS #{trump_card}"
    @game_state.dealer.hand << trump_card
  end

  def pick_trump
    @game_state.trump_state.selection_operations << :pick
    @game_state.trump_state.select_suit_as_trump @operation.suit.to_sym
    @game_state.last_player = @player_state
  end

  def draw_trump
    @game_state.trump_state.assign_new_selection_card  @operation.card
  end

  def discard_card
    @player_state.hand.delete(@operation.card)
  end

  def finish_trick
    winner = @game_state.trick_leader
    winner.scored_cards += @game_state.pile.cards
    @game_state.pile.clear
    @game_state.trick_winners << winner

    finish_round if every_player_has_no_cards?
  end

  def play_card
    @game_state.pile.add(@player_state.hand.delete(@operation.card), @player_state)
    @game_state.last_player = @player_state

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
