class Operation < ActiveRecord::Base
  belongs_to :player
  has_one :game, through: :player

  scope :deal_card!, ->(card) {
    create!(operation_type: "deal_card",
            suit: card.suit,
            rank: card.rank)
  }

  scope :pass_trump!, -> {
    create!(operation_type: "pass_trump")
  }

  scope :accept_trump!, -> {
    create!(operation_type: "accept_trump")
  }

  scope :pick_trump!, ->(card) {
    create!(operation_type: "pick_trump",
            suit: card.suit,
            rank: card.rank)
  }

  scope :play_card!, ->(card) {
    create!(operation_type: "play_card",
            suit: card.suit,
            rank: card.rank)
  }

  def deal_card?
    type == :deal_card
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
