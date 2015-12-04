
class ApplyOperation
  def initialize(game_state, operation)
    @game_state = game_state
    @operation = operation
  end

  def call
    player = @game_state.find_player(@operation.player_id)

    if @operation.deal_card?
      player.hand << @operation.card

    elsif @operation.pass_trump?
      # this doesn't change the game_state state

    elsif @operation.accept_trump? || @operation.pick_trump?
      @game_state.trump_suit = @operation.suit.to_sym

    elsif @operation.play_card?
      @game_state.pile.add(player.hand.delete(@operation.card), player)
      play_computer_turns if player == @game_state.players.first
      finish_trick if every_player_has_played?
    end
  end

  private

  def play_computer_turns
    @game_state.players[1..-1].each do |ai_player|
      play_computer_turn(ai_player)
    end
  end

  def play_computer_turn(player)
    card = player.hand.first#GenerateTurn.new(player,@game_state).call
    @game_state.pile.add(card,player)
     player.hand.delete(card)
  end

  def finish_trick
    winner = @game_state.trick_winner
    winner.scored_cards += @game_state.pile.cards
    @game_state.pile.clear

    finish_round if every_player_has_no_cards?
  end

  def finish_round

    @game_state.players.each do |player|
      player.total_score += @game_state.calculate_points(player)
      player.scored_cards.clear
    end

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
