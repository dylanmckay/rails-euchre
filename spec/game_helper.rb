require_relative 'rails_helper'
require_relative '../app/concepts/game_state'
require_relative '../app/concepts/player_state'
require_relative '../app/concepts/card'
require_relative '../app/models/operation'


def create_game_state(player_count, initial_dealer=nil)
  players = player_count.times.map { |n| create_hand(n) }
  initial_dealer ||= players.sample

  GameState.new(players, initial_dealer)
end

def create_custom_game_state(players, initial_dealer=nil)
  initial_dealer ||= players.sample

  GameState.new(players.each.with_index.map do |player,index|

    id = player.include?(:id) ? player[:id] : index
    hand = player.include?(:hand) ? player[:hand] : create_hand

    create_player_state(id, hand)
  end, initial_dealer)
end

def create_player_state(player_id, cards=create_hand, name: "John")
  PlayerState.new(id: player_id, name: name, hand: cards)
end

def create_hand
  5.times.map { create_card }
end

def create_card(suit=create_suit,
                rank=create_rank)
  Card.new(suit, rank)
end

def create_suit
  [:hearts, :diamonds, :spades, :clubs].sample
end

def create_rank
  rand(0..13)
end

def create_operation(player_id, type, suit, rank=nil)
  Operation.create!(player_id: player_id, operation_type: type,
                suit: suit, rank: rank)
end
