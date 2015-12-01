require_relative '../../app/services/generate_turn'

RSpec.describe "GenerateTurn" do
  describe "#card_to_play"do
    hand = [
      Card.new(:hearts, 9 ),
      Card.new(:hearts, 12),
      Card.new(:hearts, 10),
      Card.new(:hearts, 1 ),
      Card.new(:hearts, 13)
    ]
    player_state = PlayerState.new(id: 10, name: "jojo", hand: hand)
    game = GameState.new([player_state])
    game.trump_suit = :hearts

    context "when the pile is empty" do
      subject { GenerateTurn.new(player_state,game).card_to_play }

      it { is_expected.to eq hand[3] }
    end

    context "when the pile has low cards" do
      before { game.pile.add(Card.new(:diamonds, 9), player_state) }
      subject { GenerateTurn.new(player_state,game).card_to_play }

      it{ is_expected.to eq hand[3] }
    end

    context "when the pile has high cards" do
      before { game.pile.add(Card.new(:hearts, 11), player_state) }
      subject { GenerateTurn.new(player_state,game).card_to_play }

      it{ is_expected.to eq hand[0] }
    end
  end
end
