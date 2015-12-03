class CreateGameState

  def initialize(game_model)
    @game_model = game_model
  end


  def call
    players = make_player_states(@game_model.players)
    @state = GameState.new(players)

    @state.deck = new_deck

    # FIXME: Come up with a nicer way to do this
    operations = @game_model.players.flat_map(&:operations).sort

    operations.each do |operation|
      ApplyOperation.new(@state, operation).call
    end
    @state
  end

  private

  def make_player_states(player_models)
    player_models.map do |player_model|
      PlayerState.new(id: player_model.id,
                      name: player_model.name)
    end
  end

  def new_deck
    new_unshuffled_deck.shuffle
  end

  def new_unshuffled_deck
    full_deck.reject { |card| any_player_has_card?(card) }
  end

  def any_player_has_card?(card)
    @state.players.any? { |player| player.has_card?(card) }
  end

  def full_deck
    Card::DECK.select { |card| is_card_used?(card) }
  end

  def is_card_used?(card)
    card.rank >= 9 || card.ace?
  end
end
