class Operation < ActiveRecord::Base
  belongs_to :player

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

  def card
    if suit && rank
      Card.new(suit, rank)
    else
      fail 'the operation does not have an associated card'
    end
  end
end
