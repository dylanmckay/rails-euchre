class DealCards
  HAND_SIZE = 5

  def initialize(game_model, game_state)
    @game_model = game_model
    @game_state = game_state
  end

  def call
    deck = new_deck

    @game_model.players.each do |player_model|
      deal_cards_to_player(deck, player_model)
    end
  end

  private

  def deal_cards_to_player(deck, player)
    deck.pop(HAND_SIZE).each do |card|
      operation = player.operations.deal_card!(card)
      ApplyOperation.new(@game_state, operation)
    end
  end

  def new_deck
    Card::DECK.shuffle
  end
end
