require 'rails_helper'

RSpec.describe AI::CalculateOperation do
  player_user = User.new(name: "test", ai: false)
  let(:game)        { CreateGame.new(player_count: 2, user: player_user).call }
  let(:game_state)  { CreateGameState.new(game).call }
  subject() {
      operation = AI::CalculateOperation.new(game, game_state, first_ai_player_state).call
      ApplyOperation.new(game_state, operation).call
      operation
  }

  describe "call" do
    ai_hand = [
      Card.new(:hearts, 9) ,
      Card.new(:hearts, 10),
      Card.new(:hearts, 11),
      Card.new(:hearts, 12)
    ]
    context "after a deal_card operation" do
      context "when the AI has a bad hand, it passes on trump selection" do
        before {
          game_state.trump_state.selection_card = Card.new(:spades, 1)
          deal_specific_cards_to_player(first_ai_player, ai_hand)
        }

        it { expect( ->{ subject } ).to change{ Operation.count }.by 1 }
        it { expect( ->{ subject } ).to change{ Operation.last.type }.to :pass_trump }
      end

      context "when the AI has a good hand, it accepts the trump selection" do
        before {
          game_state.trump_state.selection_card = Card.new(:hearts, 1)
          deal_specific_cards_to_player(first_ai_player, ai_hand)
        }

        it { expect( ->{ subject } ).to change{ Operation.count }.by 1 }
        it { expect( ->{ subject } ).to change{ Operation.last.type }.to :accept_trump }
      end
    end

    context "after a pass_trump operation" do
      context "when the AI has a bad hand, it passes on trump selection" do
        before {
          game_state.trump_state.selection_card = Card.new(:spades, 1)
          deal_specific_cards_to_player(first_ai_player, ai_hand)
          first_human_player.operations.pass_trump.create!
        }

        it { expect( ->{ subject } ).to change{ Operation.count }.by 1 }
        it { expect( subject ).to be_pass_trump }
      end
    end

    context "after an accept_trump operation" do
      context "when the AI has a good hand, it accepts on trump selection and discards a card" do
        before {
          game_state.trump_state.selection_card = Card.new(:spades, 1)
          deal_specific_cards_to_player(first_ai_player, ai_hand)
          ai_accept_trump
          game.operations(reload: true)
        }

        it { expect( ->{ subject } ).to change{ game.operations.count }.by 1 }

        it { is_expected.to be_discard_card}
      end
    end

    context "In the middle of a trick," do
      before {
        deal_specific_cards_to_player(first_ai_player, ai_hand)
        deal_specific_cards_to_player(first_human_player, ai_hand)
        play_card_from_user
        game.operations(reload: true)
      }

      it { expect( ->{ subject } ).to change{ Operation.count }.by 1 }

      it { is_expected.to be_play_card }
    end

    context "when no cards are dealt" do
      it { expect( ->{ subject } ).to raise_error(Exception) }
    end
  end

  private

  def ai_accept_trump
    operation = first_ai_player.operations.accept_trump.create!
    ApplyOperation.new(game_state, operation).call
  end

  def deal_specific_cards_to_player(player, cards)
    cards.each do |card|
      operation = player.operations.deal_card.create!(card: card)
      ApplyOperation.new(game_state, operation).call
    end
    game.operations(reload: true)
  end

  def play_card_from_user
    card = first_human_player_state.hand.first
    op = first_human_player.operations.play_card.create!(suit: card.suit, rank: card.rank)
    ApplyOperation.new(game_state,op).call

  end

  def first_human_player
    game.players.find { |p| p.user.human? }
  end

  def first_human_player_state
    game_state.players.find { |p| p.player.user.human? }
  end

  def first_ai_player
    game.players.find { |p| p.user.ai? }
  end

  def first_ai_player_state
    game_state.players.find { |p| p.player.user.ai? }
  end
end
