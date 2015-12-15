class Operation < ActiveRecord::Base
  belongs_to :player
  has_one :game, through: :player

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

  def description
    case type
    when :deal_card     then "#{player.user.name} was dealt a card"
    when :pass_trump    then "#{player.user.name} passed on the trump"
    when :accept_trump  then "#{player.user.name} accepted the trump"
    when :play_card     then "#{player.user.name} played #{card}"
    when :discard_card  then "#{player.user.name} discard a card"
    when :draw_trump    then ""
    else "Undescribeable action"
    end
  end
end
