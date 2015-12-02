class CreateGameState

  def call(game_model)
    players = make_player_states(game_model.players)
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

  def make_player_states(player_models)
    player_models.map do |player_model|
      PlayerState.new(id: player_model.id,
                      name: player_model.name)
    end
  end

  def new_deck(game)
    full_deck.reject do |card|
      # Reject all cards that have already been used
      # TODO: move next line into separate function
      # TODO: split into several functions
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
