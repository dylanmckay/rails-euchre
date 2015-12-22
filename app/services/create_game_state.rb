class CreateGameState
  def initialize(game_model)
    @game_model = game_model
  end

  def call
    create_initial_state
    apply_operations
    @game_state
  end

  private

  def create_initial_state
    @player_states = make_player_states(@game_model.players)

    dealer_state = find_player_from_model(@game_model.initial_dealer)

    @game_state = GameState.new(
      players:    @player_states,
      dealer:     dealer_state,
    )
  end

  def apply_operations
    @game_model.operations.each do |operation|
      ApplyOperation.new(@game_state, operation).call
    end
  end

  def make_player_states(player_models)
    player_models.map do |player_model|
      PlayerState.new(
        player: player_model
      )
    end
  end

  def any_player_has_card?(card)
    @player_states.any? { |player| player.has_card?(card) }
  end

  def find_player_from_model(player_model)
    @player_states.find { |player| player.player == player_model }
  end
end
