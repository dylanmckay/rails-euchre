require_relative '../concepts/game_state'
require_relative '../concepts/player_state'

class CreateGameState

  def call(game_model)
    players = create_players(game_model.players)
    state = GameState.new(players)

    state.deck = new_deck(state)

    game_model.players.each do |player_model|
      player_model.operations.each do |operation|
        ApplyOperation.new(state).call(operation)
      end
    end

    state
  end

  private

  def create_players(player_models)
    player_models.map do |player_model|
      PlayerState.new(id: player_model.id,
                      name: player_model.name)
    end
  end

  def new_deck(game)
    full_deck.reject do |card|
      # Reject all cards that have already been used
      game.players.any? { |player| player.has_card?(card) }
    end.shuffle
  end

  def full_deck
    Card::DECK.select { |card| is_card_used?(card) }
  end

  def is_card_used?(card)
    card.rank >= 9 || card.ace?
  end
end
