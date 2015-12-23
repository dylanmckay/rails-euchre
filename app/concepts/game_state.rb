class GameState
  attr_reader :players
  attr_accessor :trump_state, :dealer, :pile, :deck,
    :trick_winners, :round_winners, :last_player

  def initialize(players:, dealer:, pile: Pile.new)
    @dealer = dealer
    @pile = pile
    @players = players
    @deck = Deck.new
    @trump_state = TrumpState.new(deck, players.size)
    @last_player = nil

    @round_winners = []
    @trick_winners = []
  end

  def player_index(player_model)
    @players.index { |player| player.player == player_model }
  end

  def find_player(player_model)
    @players.find{ |player_state|
      player_state.player == player_model
    }
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
    @players.all? { |p| p.hand.count == Config::HAND_CARD_COUNT }
  end

  def in_trump_selection?
    !@trump_state.selected?
  end

  def in_discard_phase?
    @dealer.hand.length == Config::HAND_CARD_COUNT+1
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

  def main_player
    @players.find{ |p| p.player.user.human? }
  end

  def ai_players
    @players.select { |p| p.player.user.ai? }
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
    if @pile.leading_card
      if is_trump?(@pile.leading_card)
        @trump_state.suit
      else
        @pile.leading_card.suit
      end
    else
      nil
    end
  end

  def valid_turn?(player_state, card)
    @pile.empty?  ||
      valid_card?(card) ||
      !player_has_leading_cards?(player_state)
  end

  def valid_card?(card)
    if is_leading_suit?(card)
      true
    elsif leading_suit == @trump_state.suit
      is_trump?(card)
    else
      false
    end
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
end
