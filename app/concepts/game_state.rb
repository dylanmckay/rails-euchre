require_relative 'pile'

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

  def in_progress?
    @players.each.any? { |player| !player.hand.empty? }
  end

  def best_card_in_stack(stack)
    stack.inject do |best,curr|
      best = highest_scoring_card(best, curr, stack.first.suit)
    end
  end

  def best_card_in_pile
    best_card_in_stack(@pile.cards)
  end

  def worst_card_in_stack(stack = @pile.cards)
    stack.inject do |best,curr|
      best = highest_scoring_card(best, curr, stack.first.suit) == best ? curr : best
    end
  end

  #TODO currently basic point score based on tricks won in a round
  def player_points
    players.map { |p| calculate_points(p)}
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

  def highest_scoring_card(subject, other, leading_suit = @pile.cards.first.suit)
    if is_trump?(subject) && is_trump?(other)
      highest_when_trump(subject,other)
    elsif subject.suit == other.suit
      highest_when_not_trump(subject,other)
    elsif subject.suit != other.suit
      highest_when_different_suit(subject,other,leading_suit)
    end
  end

  def is_trump?(card)
    card.suit == trump_suit || (card.partner_suit == trump_suit && card.jack?)
  end

  def sort_stack(stack)
    sorted = []
    while stack.length != sorted.length
      card = best_card_in_stack(stack-sorted)
      sorted << card
    end
    sorted
  end

  private

  def won_tricks(player)
    player.scored_cards.length / players.length
  end

  def highest_when_not_trump(subject, other)
    (subject > other && !other.ace?) || subject.ace?  ? subject : other
  end

  def highest_when_different_suit(subject, other, leading_suit)
    if is_trump?(subject)
      subject
    elsif is_trump?(other)
      other
    elsif subject.suit == leading_suit
      subject
    elsif other.suit == leading_suit
      other
    else
      subject
    end
  end

  def highest_when_trump(subject, other)
    card_value(subject) > card_value(other) ? subject : other
  end

  def card_value(card)
    if card.jack? && is_trump?(card)
      trump_card_value = 16
      trump_card_value -=1 if card.suit != trump_suit
      trump_card_value
    else
      card.ace? ? 14 : card.rank
    end
  end
end
