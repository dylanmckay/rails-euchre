class Operation < ActiveRecord::Base
  belongs_to :player
  composed_of :card, mapping: [ %w(suit suit), %w(rank rank) ], allow_nil: true
  OPERATION_TYPES = %w(deal_card pass_trump accept_trump pick_trump play_card draw_trump discard_card)

  OPERATION_TYPES.each do |type|
    scope type, -> { where(operation_type: type) }

    define_method("#{type}?") do
      operation_type == type
    end
  end

  def type
    operation_type.to_sym
  end

  #TODO maybe write a validation to confirm presences of both or absensece of both
  def card
    if suit && rank
      Card.new(suit, rank)
    else
      raise 'the operation does not have an associated card'
    end
  end
end
