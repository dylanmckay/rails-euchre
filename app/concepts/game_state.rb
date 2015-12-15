class GameState
  attr_reader :players
  attr_accessor :trump_state, :dealer, :pile, :deck,
    :trick_winners, :round_winners, :last_player

  def initialize(players:, dealer:, pile: Pile.new)
    @dealer = dealer
    @pile = pile
    @players = players
    @deck = Deck.new
    #TODO refactor this so they're not co-dependent?
    @trump_state = TrumpState.new(self, deck)
    @last_player = nil

    @round_winners = []
    @trick_winners = []
  end

  def player_index(id)
    @players.index { |player| player.id == id }
  end

  def find_player(id)
    @players.find { |player| player.id == id }
  end

  def trick_in_progress?
     !@pile.empty?
  end

  def end_of_trick?
    (round_count > 0 ||
     trick_count > 0) &&
    !trick_in_progress?
  end

  def round_in_progress?
    @players.any? { |player| !player.hand.empty? }
  end

  def start_of_round?
    @players.all? { |p| p.hand.empty? }
  end

  def started_new_round?
    # USE CONSTANTS!!!
    @players.all? { |p| p.hand.count == 5 }
  end

  def end_of_round?
    round_count > 0 && !round_in_progress?
  end

  def in_trump_selection?
    !@trump_state.selected?
  end

  def in_discard_phase?
    #TODO refactor to not use constants
    @dealer.hand.length == 6
  end

  def best_card_in_pile
    SortStack.new(self, @pile.cards).call.first
  end

  def round_count
    @round_winners.count
  end

  def trick_count
    @trick_winners.count
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
    @players.find{ |p| p.human? }
  end

  def ai_players
    @players.select { |p| p.ai? }
  end

  def trick_leader
    @pile.card_owner(best_card_in_pile)
  end

  def round_leaders
    max_score = @players.max_by { |player| player.total_score }.total_score
    leaders = @players.select { |player| player.total_score == max_score }

    if leaders.length != @players.length
      leaders
    else
      [] # we don't really have leads if everyone is equal
    end
  end

  def round_leader
    leaders = round_leaders

    leaders.first if leaders.length == 1
  end

  def is_trump?(card)
    (card.suit == trump_suit ||
      (card.partner_suit == trump_suit && card.jack?))
  end

  def is_leading_suit?(card)
    card.suit == leading_suit
  end

  def leading_suit
    @pile.leading_suit
  end

  def valid_turn?(player_state, card)
    @pile.empty? ||
      card.suit == leading_suit ||
      !player_has_leading_cards?(player_state)
  end

  def trump_suit
    @trump_state.suit != nil ? @trump_state.suit : @trump_state.selection_suit
  end

  def player_left_of(player)
    player_index = @players.index(player)
    left_player_index = (player_index + 1) % @players.length

    @players[left_player_index]
  end

  private

  def player_has_leading_cards?(player_state)
    player_state.hand.any? { |c| c.suit == leading_suit }
  end

  def won_trick_count_for_player(player)
    player.scored_cards.length / players.length
  end
end
