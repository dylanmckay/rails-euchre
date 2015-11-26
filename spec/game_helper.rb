require_relative 'rails_helper'
require_relative '../app/concepts/game_state'
require_relative '../app/concepts/hand'
require_relative '../app/concepts/card'
require_relative '../app/models/action'


def create_game_state(player_count)
  players = player_count.times.map { |n| create_hand(n) }
  GameState.new(players)
end

def create_custom_game_state(hands)
  GameState.new(hands.each.with_index.map do |player,index|

    id = player.include?(:id) ? player[:id] : index
    cards = player.include?(:hand) ? player[:hand] : create_cards

    create_hand(id, cards)
  end)
end

def create_hand(player_id, cards=create_cards)
  Hand.new(player_id, cards)
end

def create_cards
  5.times.map { create_card }
end

def create_card(suit=create_suit,
                value=create_value)
  Card.new(suit, value)
end

def create_suit
  ["HEARTS", "DIAMONDS", "SPADES", "CLUBS"].sample
end

def create_value
  rand(0..13)
end

def create_action(player_id, type, suit, value=nil)
  Action.create!(player_id: player_id, action_type: type,
                suit: suit, value: value)
end

