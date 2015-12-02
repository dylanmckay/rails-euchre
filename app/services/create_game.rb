class CreateGame
  HAND_SIZE = 5
  AI_NAMES = [
    'Bill',
    'John',
    'Sally',
    'Andy',
    'Joseph',
  ]

  # TODO: services should have data in initializers
  def call(player_count)
    game = Game.create!

    player_count.times do
      game.players.create!(:name => AI_NAMES.sample)
    end

    deal_cards(game)

    game
  end

  private

  def deal_cards(game)
    deck = new_deck

    game.players.each { |player| deal_cards_to_player(deck, player) }
  end

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
    Card::DECK.select { |card| is_card_used?(card) }.shuffle
  end

  # TODO: Only place valid cards insode CARD::DECK
  # Don't over-genericise
  def is_card_used?(card)
    card.rank >= 9 || card.ace?
  end

end
