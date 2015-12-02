require_relative '../concepts/card'

HAND_SIZE = 5
NAMES = [
  'Bill',
  'John',
  'Sally',
  'Andy',
  'Joseph',
]

class CreateGame
  def call(player_count)
    game = Game.create!

    player_count.times do
      game.players.create!(:name => NAMES.sample)
    end

    deal_cards(game)

    game
  end

  private

  def deal_cards(game)
    deck = new_deck

    game.players.each do |player|
      deck.pop(HAND_SIZE).each do |card|
        player.operations.create!(operation_type: :deal_card,
                               suit: card.suit, value: card.rank)
      end
    end
  end

  def new_deck
    Card::DECK.select { |card| is_card_used?(card) }.shuffle
  end

  def is_card_used?(card)
    card.rank >= 9 || card.ace?
  end

end
