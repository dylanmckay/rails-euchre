require_relative 'rails_helper'
require_relative '../app/concepts/game_state'
require_relative '../app/concepts/player_state'
require_relative '../app/concepts/card'
require_relative '../app/models/operation'

def create_game(players: [],
                dealer: players.first,
                trump: :hearts)

  GameState.new(
    players: players,
    dealer: dealer,
    trump_suit: trump,
  )
end

def create_game_state(player_count:,
                      dealer: nil,
                      trump: nil)
  players = player_count.times.map { |n| create_hand(n) }
  dealer ||= players.first
  trump ||= :hearts

  GameState.new(players: players, dealer: dealer,
                trump_suit: trump)
end

def create_custom_game_state(players:,
                             dealer: nil,
                             trump_suit: nil)
  players = players.each.with_index.map do |player,index|
    id = player.include?(:id) ? player[:id] : index
    hand = player.include?(:hand) ? player[:hand] : create_hand

    create_player_state(id, hand)
  end

  dealer ||= players.first
  trump_suit ||= :hearts

  GameState.new(players: players, dealer: dealer,
                trump_suit: trump_suit)
end

def create_players(count)
  count.times.map.with_index { |n| create_player_state(n) }
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
  ([1] + (8..13).to_a).sample
end

def create_operation(player_id, type, suit=nil, rank=nil)
  Operation.create!(
    player_id:      player_id,
    operation_type: type,
    suit:           suit,
    rank:           rank
  )
end
