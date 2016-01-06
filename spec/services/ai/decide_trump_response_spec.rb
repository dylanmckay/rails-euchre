require 'rails_helper'

RSpec.describe AI::DecideTrumpResponse do
  player_user = User.new(name: "test", ai: false)
  let(:game)        { CreateGame.new(player_count: 2, user: player_user).call }
  let(:game_state)  { CreateGameState.new(game).call }
  subject(:test)    {  AI::DecideTrumpResponse.new(game_state, first_ai_player_state).call  }

  describe "call" do

    context "When the AI has a bad hand" do
        before {
          ai_hand = [
            Card.new(:hearts, 9) ,
            Card.new(:hearts, 10),
            Card.new(:hearts, 11),
            Card.new(:hearts, 12)
          ]
          game_state.trump_state.selection_card = Card.new(:spades, 1)
          deal_specific_cards_to_player(first_ai_player, ai_hand)
        }

        it { is_expected.to eq :pass }

    end

    context "When the AI has a good hand" do
      before {
        ai_hand = [
          Card.new(:hearts, 9) ,
          Card.new(:hearts, 10),
          Card.new(:hearts, 11),
          Card.new(:hearts, 12)
        ]
        game_state.trump_state.selection_card = Card.new(:hearts, 1)
        deal_specific_cards_to_player(first_ai_player, ai_hand)
      }

      it { is_expected.to eq :accept }
    end

    context "When the AI has an okay hand" do
      before {
        ai_hand = [
          Card.new(:hearts, 9) ,
          Card.new(:hearts, 10),
          Card.new(:clubs, 11),
          Card.new(:spades, 12)
        ]
        game_state.trump_state.selection_card = Card.new(:hearts, 1)
        deal_specific_cards_to_player(first_ai_player, ai_hand)
      }

      it { is_expected.to eq :pass }
    end
  end

  private

  def deal_specific_cards_to_player(player, cards)
    cards.each do |card|
      operation = player.operations.deal_card.create!(card: card)
      ApplyOperation.new(game_state, operation).call
    end
    game.operations(reload: true)
  end

  def first_ai_player
    game.players.find { |p| p.user.ai? }
  end

  def first_ai_player_state
    game_state.players.find { |p| p.player.user.ai? }
  end
end
