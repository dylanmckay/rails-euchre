
require_relative '../concepts/card'

class Operation < ActiveRecord::Base
  belongs_to :player


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
    action_type.to_sym
  end

  def card
    if suit && value
      Card.new(suit, value)
    else
      fail 'the action does not have an associated card'
    end
  end
end
