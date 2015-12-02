
class ApplyOperation
  def initialize(game, operation)
    @game = game
    @operation = operation
  end

  def call
    player = @game.find_player(@operation.player_id)

    if @operation.deal_card?
      player.hand << @operation.card

    elsif @operation.pass_trump?
      # this doesn't change the game state

    elsif @operation.accept_trump? || @operation.pick_trump?
      @game.trump_suit = @operation.suit.to_sym

    elsif @operation.play_card?
      @game.pile.add(player.hand.delete(@operation.card), player)

    elsif operation.play_card?
      @game.pile.add(player.hand.delete(operation.card), player)
      
      finish_round if every_player_has_played?
    end
  end

  private

  def finish_round
    winner = @game.round_winner

    winner.scored_cards += @game.pile.cards
    @game.pile.clear
  end

  def every_player_has_played?
    @game.pile.length == @game.players.length
  end
end
