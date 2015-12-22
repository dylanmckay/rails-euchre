class Operation < ActiveRecord::Base
  belongs_to :player

  # TODO: research enums
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

  # TODO: this does not belong here, put into a presenter
  def description
    case type
    when :deal_card     then "#{player.user.name} was dealt a card"
    when :pass_trump    then "#{player.user.name} passed on the trump"
    when :accept_trump  then "#{player.user.name} accepted the trump"
    when :play_card     then "#{player.user.name} played #{card}"
    when :discard_card  then "#{player.user.name} discard a card"
    when :draw_trump    then "Drew a new trump card"
    else "Undescribeable action"
    end
  end
end
