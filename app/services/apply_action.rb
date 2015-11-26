
class ApplyAction
  def initialize(game)
    @game = game
  end

  def call(action)

    hand = @game.find_hand(action.player_id)

    if action.deal_card?
      hand.cards << action.card
    elsif action.pass_trump?
      # this doesn't change the game state
    elsif action.accept_trump? || action.pick_trump?

      @game.trump_suit = action.suit
    elsif action.play_card?

      card = hand.cards.delete(action.card)
      fail 'the card must exist in the players hand' if !card

      @game.pile << card
    else
      fail 'unknown action'
    end
  end
end

