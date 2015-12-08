class GameState
  attr_reader :players
  attr_accessor :trump_state, :dealer, :pile, :deck

  def initialize(players:, dealer:, trump_suit:)
    @dealer = dealer
    @pile = Pile.new
    @deck = []
    @players = players
    @trump_state = TrumpState.new(@players, @dealer, trump_suit)
  end

  def find_player(id)
    @players.find { |player| player.id == id }
  end

  def round_in_progress?
    @players.each.any? { |player| !player.hand.empty? }
  end

  def in_trump_selection?
    !@trump_state.selected?
  end

  def best_card_in_pile
    SortStack.new(self, @pile.cards).call.first
  end

  def calculate_points(player)
    if won_trick_count_for_player(player) == 5
      2
    elsif won_trick_count_for_player(player) >= 3
      1
    else
      0
    end
  end

  def main_player
    @players.first
  end

  def ai_players
    @players[1..-1]
  end

  def trick_winner
    @pile.card_owner(best_card_in_pile)
  end

  def is_trump?(card)
    card.suit == trump_suit ||
      (card.partner_suit == trump_suit && card.jack?)
  end

  def is_leading_suit?(card)
    !pile.empty? && card.suit == pile.cards.first.suit
  end

  # FIXME: this is unused
  def valid_play_card_turn?(player_state, card, leading_suit)
    card.suit == leading_suit || !player_has_leading_cards?(player_state, leading_suit)
  end

  def trump_suit
    @trump_state.suit
  end

  def trump_suit=(suit)
    @trump_state.suit = suit
  end

  private

  def player_has_leading_cards?(player_state, leading_suit)
    player_state.hand.any? { |c| c.suit == leading_suit }
  end

  def won_trick_count_for_player(player)
    player.scored_cards.length / players.length
  end
end
