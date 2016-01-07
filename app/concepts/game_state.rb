class GameState
  attr_reader :players, :trump_state, :pile, :deck,
    :trick_winners, :round_winners

  attr_accessor :dealer, :last_player

  def initialize(players:, dealer:, pile: Pile.new, deck: Deck.new)
    @dealer = dealer
    @pile = pile
    @players = players
    @deck = deck
    @trump_state = TrumpState.new(deck, players.size)
    @last_player = nil

    @round_winners = []
    @trick_winners = []
  end

  def find_player(player_model)
    @players.find { |player_state|  player_state.player == player_model }
  end

  def start_of_trick?
    pile.length == 0
  end

  def end_of_round?
    @players.all? { |p| p.hand.empty? }
  end

  def start_of_round?
    @players.all? { |p| p.hand.count == Player::INITIAL_CARD_COUNT }
  end

  def current_phase
    if !@trump_state.trump_selected?
      :trump_selection
    elsif dealer.hand.length == Player::DEALER_DISCARD_CARD_COUNT
      :discard
    else
      :trick
    end
  end

  def round_count
    @round_winners.count
  end

  def trick_count
    @trick_winners.count
  end

  def main_player
    @players.find { |p| p.player.user.human? }
  end

  def ai_players
    @players.select { |p| p.player.user.ai? }
  end

  def trick_leader
    @pile.card_owner(best_card_in_pile)
  end

  def round_leaders
    # max_score = @players.max_by { |player| player.total_score }.total_score TODO
    max_score = @players.map(&:total_score).max
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

  def is_trump?(card) #TODO maybe remove 'is' here
    card.suit == trump_suit ||
      (card.partner_suit == trump_suit && card.jack?)
  end

  def leading_suit
    if @pile.leading_card
      if is_trump?(@pile.leading_card)
        trump_suit
      else
        @pile.leading_card.suit
      end
    end
  end

  def valid_play?(player_state, card)
    @pile.empty? ||
      can_play_card?(card) ||
      !player_has_leading_cards?(player_state)
  end

  def human_can_play_card?(card)
    valid_play?(main_player, card) && main_player.hand.include?(card) && current_phase != :trump_selection
  end

  def trump_suit
    @trump_state.trump_selected? ? @trump_state.suit : @trump_state.selection_suit
  end

  def player_left_of(player)
    player_index = @players.index(player)
    left_player_index = (player_index + 1) % @players.length

    @players[left_player_index]
  end

  private

  def can_play_card?(card)
    if leading_suit == card.suit
      true
    elsif leading_suit == trump_suit
      is_trump?(card)
    else
      false
    end
  end

  def player_has_leading_cards?(player_state)
    player_state.hand.any? { |c| c.suit == leading_suit }
  end

  def best_card_in_pile
    SortStack.new(self, @pile.cards).call.first
  end
end
