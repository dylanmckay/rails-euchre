
require_relative '../concepts/card'

class Action < ActiveRecord::Base
  belongs_to :player

  DEAL_CARD = "deal_card"
  PASS_TRUMP = "pass_trump"
  ACCEPT_TRUMP = "accept_trump"
  PICK_TRUMP = "play_trump"
  PLAY_CARD = "play_card"

  def deal_card?
    action_type == DEAL_CARD
  end

  def pass_trump?
    action_type == PASS_TRUMP
  end

  def accept_trump?
    action_type == ACCEPT_TRUMP
  end

  def pick_trump?
    action_type == PICK_TRUMP
  end

  def play_card?
    action_type == PLAY_CARD
  end

  def card
    if suit && value
      Card.new(suit, value)
    else
      fail 'the action does not have an associated card'
    end
  end
end

