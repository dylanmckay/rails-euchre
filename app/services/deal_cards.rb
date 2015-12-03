class DealCards
  HAND_SIZE = 5

  def initialize(game)
    @game = game
  end

  def call
    deck = new_deck

    @game.players.each { |player| deal_cards_to_player(deck, player) }
  end

  private

  def deal_cards_to_player(deck, player)
    deck.pop(HAND_SIZE).each do |card|
      player.operations.create!(
        operation_type: :deal_card,
        suit: card.suit,
        rank: card.rank
      )
    end
  end

  def new_deck
    Card::DECK.shuffle
  end
end
