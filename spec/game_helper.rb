require_relative 'rails_helper'
require_relative '../app/concepts/game_state'
require_relative '../app/concepts/player_state'
require_relative '../app/concepts/card'
require_relative '../app/models/operation'

def create_game(players: [], dealer: players.first, trump: :hearts)
  state = GameState.new(
    players: players,
    dealer: dealer
  )
  state.trump_state.select_suit_as_trump(trump)
  state
end

def create_game_model(players: [],
                      dealer: players.first)
  Game.create!(
    players: players,
    initial_dealer: dealer,
  )
end

def create_player_models(count)
  human_user = User.new(name: "Bill")
  ai_user = User.new(name: "Tim", ai: true)

  human_players = [
    Player.new(user: human_user)
  ]

  ai_players = (1...count).map do
    Player.new(user: ai_user)
  end
  human_players + ai_players
end

def create_game_state(player_count:,
                      dealer: nil,
                      trump: :hearts)
  players = player_count.times.map { |n| create_hand(n) }
  dealer ||= players.first

  GameState.new(players: players, dealer: dealer,
                trump_suit: trump)
end

def create_player_model
    Player.new(user: User.new(name: "Jax"))
end

def create_custom_game_state(players:,
                             dealer: nil,
                             trump_suit: :hearts)
  players = players.each.with_index.map do |player,index|
    hand = player.include?(:hand) ? player[:hand] : create_hand

    create_player_state(player: player[:player_model], cards: hand)
  end

  dealer ||= players.first

  state = GameState.new(players: players, dealer: dealer)
  state.trump_state.select_suit_as_trump trump_suit
  state
end

def create_players(count)
  create_player_models(count).map do |player|
    create_player_state(player: player)
  end
end

def create_player_state(player: create_player_model, cards: create_hand)
  PlayerState.new(player: player, hand: cards)
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

def create_operation(player, type, suit=nil, rank=nil)
  player.operations.new(
    operation_type: type,
    suit:           suit,
    rank:           rank
  )
end
