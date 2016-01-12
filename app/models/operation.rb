class Operation < ActiveRecord::Base
  OPERATION_TYPES = %w(deal_card pass_trump accept_trump pick_trump play_card draw_trump discard_card)
  OPERATION_NAMES = OPERATION_TYPES.map(&:to_s)

  belongs_to :player
  composed_of :card, mapping: [ %w(suit suit), %w(rank rank) ], allow_nil: true

  validates :operation_type, null: false, inclusion: { in: OPERATION_NAMES }
  validate :suit_and_rank_are_mutually_existing
  validate :suit_is_null_or_valid
  validate :rank_is_null_or_allowed_in_euchre

  OPERATION_TYPES.each do |type|
    scope type, -> { where(operation_type: type) }

    define_method("#{type}?") do
      operation_type == type
    end
  end

  def symbol
    operation_type.to_sym
  end

  def card
    if suit && rank
      Card.new(suit, rank)
    else
      raise 'the operation does not have an associated card'
    end
  end

  private

  def suit_and_rank_are_mutually_existing
    if suit.nil? != rank.nil?
      errors.add(:suit, "an operation must set both 'suit' and 'rank' or neither")
    end
  end

  def suit_is_null_or_valid
    if suit
      is_valid = Card::SUIT_NAMES.include?(suit)

      if !is_valid
        errors.add(:suit, "suit must be one of '#{Card::SUIT_NAMES.join(', ')}'")
      end
    end
  end

  def rank_is_null_or_allowed_in_euchre
    if rank
      is_valid = rank == Card::ACE || Card::EUCHRE_CARD_RANGE.include?(rank)

      if !is_valid
        errors.add(:rank, "card rank must be 1 or between 9 and 13 (inclusive)")
      end
    end
  end
end
