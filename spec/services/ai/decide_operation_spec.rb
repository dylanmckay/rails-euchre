require 'rails_helper'

RSpec.describe AI::DecideOperation do
  player_user = User.new(name: "test", ai: false)
  let(:game)        { CreateGame.new(player_count: 2, user: player_user).call }
  let(:game_state)  { CreateGameState.new(game).call }
  subject(:test)    {
    -> { AI::DecideOperation.new(game, game_state, first_ai_player_state).call }
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

        it { is_expected.to change{ Operation.count }.by 1 }
        it { is_expected.to change{ Operation.last.type }.to :pass_trump }
      end

      context "when the AI has a good hand, it accepts the trump selection" do
        before {
          game_state.trump_state.selection_card = Card.new(:hearts, 1)
          deal_specific_cards_to_player(first_ai_player, ai_hand)
        }

        it { is_expected.to change{ Operation.count }.by 1 }
        it { is_expected.to change{ Operation.last.type }.to :accept_trump }
      end
    end

    context "after a pass_trump operation" do
      context "when the AI has a bad hand, it passes on trump selection" do
        before {
          game_state.trump_state.selection_card = Card.new(:spades, 1)
          deal_specific_cards_to_player(first_ai_player, ai_hand)
          first_human_player.operations.create!( operation_type: "pass_trump" )
        }

        it { is_expected.to change{ Operation.count }.by 1 }
        it { expect( subject.call ).to satisfy{ Operation.last.pass_trump? } }
      end
    end

    context "In the middle of a trick," do
      before {
        deal_specific_cards_to_player(first_ai_player, ai_hand)
        play_card_from_user
      }

      it { is_expected.to change{ Operation.count }.by 1 }
      #FIXME 'satisfy' doesn't seem like a good idea and should be used sparcely, find an alternative for this situation
      it { is_expected.to satisfy{ Operation.last.play_card? } }
    end

    context "when no cards are dealt" do
      it { is_expected.to raise_error(Exception) }
    end
  end

  private

  def deal_specific_cards_to_player(player, cards)
    cards.each do |card|
      operation = player.operations.deal_card.create!(card.to_h)
      ApplyOperation.new(game_state, operation).call
    end
    game.operations(reload: true)
  end

  def play_card_from_user
    card = first_human_player_state.hand.sample
    first_human_player.operations.create!(operation_type: "play_card", suit: "hearts", rank: 1)
  end

  def first_human_player
    game.players.find { |p| p.human? }
  end

  def first_ai_player
    game.players.find { |p| p.ai? }
  end

  def first_human_player_state
    game_state.players.find { |p| p.human? }
  end

  def first_ai_player_state
    game_state.players.find { |p| p.ai? }
  end
end
