require_relative 'rails_helper'
require_relative '../app/concepts/game_state'
require_relative '../app/concepts/player_state'
require_relative '../app/concepts/card'
require_relative '../app/models/action'


def create_game_state(player_count)
  players = player_count.times.map { create_player_state }
  GameState.new(players)
end

def create_player_state
  id = 1 # TODO: better ID
  PlayerState.new(id, create_hand)
end

def create_hand
  5.times.map { create_card }
end

def create_card
  Card.new(create_suit, create_value)
end

def create_suit
  ["HEARTS", "DIAMONDS", "SPADES", "CLUBS"].sample
end

def create_value
  rand(0..13)
end

def create_action(type, suit, value=nil)
  Action.create!(action_type: type, suit: suit, value: value)
end

