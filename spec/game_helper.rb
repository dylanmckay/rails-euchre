require_relative 'rails_helper'
require_relative '../app/concepts/game_state'
require_relative '../app/concepts/player_state'
require_relative '../app/concepts/card'
require_relative '../app/models/action'


def create_game_state(player_count)
  players = player_count.times.map { |n| create_hand(n) }
  GameState.new(players)
end

def create_custom_game_state(players)
  GameState.new(players.each.with_index.map do |player,index|

    id = player.include?(:id) ? player[:id] : index
    hand = player.include?(:hand) ? player[:hand] : create_hand

    create_player_state(id, hand)
  end)
end

def create_player_state(player_id, cards=create_hand, name: "John")
  PlayerState.new(id: player_id, name: name, hand: cards)
end

def create_hand
  5.times.map { create_card }
end

def create_card(suit=create_suit,
                value=create_value)
  Card.new(suit, value)
end

def create_suit
  [:hearts, :diamonds, :spades, :clubs].sample
end

def create_value
  rand(0..13)
end

def create_action(player_id, type, suit, value=nil)
  Action.create!(player_id: player_id, action_type: type,
                suit: suit, value: value)
end
