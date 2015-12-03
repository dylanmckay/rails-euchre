
class GameState
  attr_reader :players
  attr_accessor :trump_suit, :pile, :deck

  def initialize(players)
    @trump_suit = nil
    @pile = Pile.new
    @deck = []
    @players = players
  end

  def find_player(id)
    @players.find { |player| player.id == id }
  end

  def round_in_progress?
    @players.each.any? { |player| !player.hand.empty? }
  end

  def best_card_in_pile
    SortStack.new(self, @pile.cards).call.first
  end

  def calculate_points(player)
    if won_tricks(player) == 5
      2
    elsif won_tricks(player) >= 3
      1
    else
      0
    end
  end

  def round_winner
    @pile.card_owner(best_card_in_pile)
  end

  def is_trump?(card)
    card.suit == trump_suit || (card.partner_suit == trump_suit && card.jack?)
  end

  def is_leading_suit?(card)
    !pile.empty? && card.suit == pile.cards.first.suit
  end

  def valid_play_card_turn?(player_state, card, leading_suit)
    card == leading_suit || !player_has_leading_cards?(player_state)
  end

  private

  def player_has_leading_cards?(player_state)
    player_state.hand.any? { |c| c.suit == leading_suit }
  end

  def won_tricks(player)
    player.scored_cards.length / players.length
  end
end
