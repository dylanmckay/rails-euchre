class Operation < ActiveRecord::Base
  belongs_to :player
  # TODO: research enums

  # TODO: it is more idiomatic to write a helper method or
  # just use 'operation.player.game'
  has_one :game, through: :player

  # From roger
  # OPERATION_TYPES = %w(deal_card pass_trump accept_trump)
  #
  # OPERATION_TYPES.each do |type|
  #   scope type, -> { where(operation_type: type) }
  #
  #   define_method("#{type}?") do
  #     operation_type == type
  #   end
  # end
  #
  # Might be a better idea to store scope names as an array for
  # validation and to create scopes that way.
  scope :deal_card,   -> { where(operation_type: "deal_card")     }
  scope :pass_trump,  -> { where(operation_type: "pass_trump")    }
  scope :accept_trump,-> { where(operation_type: "accept_trump")  }
  scope :pick_trump,  -> { where(operation_type: "pick_trump")    }
  scope :play_card,   -> { where(operation_type: "play_card")     }
  scope :draw_trump,  -> { where(operation_type: "draw_trump")    }
  scope :discard_card, ->{ where(operation_type: "discard_card")  }


  def deal_card?
    type == :deal_card
  end

  def discard_card?
    type == :discard_card
  end

  def pass_trump?
    type == :pass_trump
  end

  def accept_trump?
    type == :accept_trump
  end

  def pick_trump?
    type == :pick_trump
  end

  def play_card?
    type == :play_card
  end

  def draw_trump?
    type == :draw_trump
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

  # TODO: this does not belong here
  def description
    case type
    when :deal_card     then "#{player.user.name} was dealt a card"
    when :pass_trump    then "#{player.user.name} passed on the trump"
    when :accept_trump  then "#{player.user.name} accepted the trump"
    when :play_card     then "#{player.user.name} played #{card}"
    when :discard_card  then "#{player.user.name} discard a card"
    when :draw_trump    then "Drew a card"
    else "Undescribeable action"
    end
  end
end
