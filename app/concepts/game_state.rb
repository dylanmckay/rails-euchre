require_relative 'pile'

class GameState

  attr_reader :players
  attr_accessor :trump_suit, :pile

  def initialize(players)
    @trump_suit = nil
    @pile = Pile.new
    @players = players
  end

  def find_player(id)
    @players.find { |player| player.id == id }
  end

  def in_progress?
    @players.each.any? { |player| !player.hand.empty? }
  end

  def best_card(stack = @pile.cards)
    stack.inject do |best,curr|
      best = highest_scoring_card(best,curr,stack.first.suit)
    end
  end

  #TODO currently basic point score based on tricks won in a round
  def player_points
    players.map do |player|
      calculate_points(player)
    end
  end

  def calculate_points(player)
    if player.scored_cards.length/players.length == 5
      2
    elsif player.scored_cards.length/players.length >= 3
      1
    else
      0
    end
  end

  def round_winner
    @pile.card_owner(best_card)
  end

  def highest_scoring_card(subject, other, leading_suit)
    if is_trump?(subject) && is_trump?(other)
      highest_when_trump(subject,other)
    elsif subject.suit == other.suit
      highest_when_not_trump(subject,other)
    elsif subject.suit != other.suit
      highest_when_different_suit(subject,other,leading_suit)
    end
  end

  private

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

  def is_trump?(card)
    card.suit == trump_suit || (card.partner_suit == trump_suit && card.jack?)
  end

  def highest_when_trump(subject, other)
    card_trump_value(subject) > card_trump_value(other) ? subject : other
  end

  def card_trump_value(card)
    card_real_value = card_value(card)
    if card.jack?
      card_real_value = 16
      card_real_value -=1 if card.suit != trump_suit
    end
    card_real_value
  end

  def card_value(card)
    card.ace? ? 14 : card.rank
  end
end
