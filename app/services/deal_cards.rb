class DealCards
  def initialize(game_model, game_state:, deck: Deck.new)
    @game_model = game_model
    @game_state = game_state
    @deck = deck
  end

  def call
    @game_model.players.each do |player_model|
      deal_cards_to_player(player_model)
    end
  end

  private

  def deal_cards_to_player(player)
    @deck.pop(Player::INITIAL_CARD_COUNT).each do |card|
      operation = player.operations.deal_card.create!(card.to_h)
      ApplyOperation.new(@game_state, operation).call
    end
  end

end
