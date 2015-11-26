#compare_card.rb

class CompareCard
  def initialize

  end

  def call(subject,other,trump,leading_suit)

    if(is_trump?(subject,trump)&&is_trump?(other,trump))
      compare_value_trump(subject,other,trump)
    elsif (subject.suit == other.suit)
      (subject > other && !other.ace?) || subject.ace?  ? subject : other
    elsif(subject.suit != other.suit)
      compare_when_different_suit(subject,other,trump,leading_suit)
    end
  end

  private

  def compare_when_different_suit(subject,other,trump,leading_suit)
    if is_trump?(subject,trump)
      subject
    elsif is_trump?(other,trump)
      other
    elsif subject.suit == leading_suit
      subject
    elsif other.suit == leading_suit
      other
    else
      subject
    end
  end

  def is_trump?(card,trump)
    card.suit == trump || (card.partner_suit == trump && card.jack?)
  end

  def compare_value(subject,other)
    return other if subject.ace? && other.rank > subject.rank
    return subject
  end

  def compare_value_trump(subject,other,trump)
    subject_value = card_trump_value(subject,trump)
    other_value = card_trump_value(other,trump)
    subject_value > other_value ? subject : other
  end

  def card_trump_value(card,trump)
    card_real_value = card_value(card)
    if card.jack?
      card_real_value = 16
      card_real_value -=1 if card.suit != trump
    end
    card_real_value
  end

  def card_value(card)
    card.ace? ? 14 : card.rank
  end
end
