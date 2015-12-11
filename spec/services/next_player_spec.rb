describe NextPlayer do
  let(:players) { create_players(2) }

  let(:state) {
    create_game(
      players: players,
      trump: nil,
      dealer: players[0],
    )
  }

  subject(:next_player) { NextPlayer.new(state).call }

  context "when performing trump selection" do
    context "on the first turn" do
      it { is_expected.to eq state.player_left_of(state.dealer) }
    end

    context "when the dealer passed" do
      before {
        ApplyOperation.new(
          state,
          Operation.pass_trump.create!(player_id: state.dealer.id),
        ).call
      }

      it { is_expected.to eq state.player_left_of(state.last_player) }
    end

    context "when the dealer and the second player passed" do
      let(:first_player) { state.dealer }
      let(:second_player) { state.player_left_of(first_player) }
      let(:third_player) { state.player_left_of(second_player) }

      before {
        ApplyOperation.new(
          state,
          Operation.pass_trump.create!(player_id: first_player.id),
        ).call

        ApplyOperation.new(
          state,
          Operation.pass_trump.create!(player_id: second_player.id),
        ).call
      }

      it { is_expected.to eq third_player }
    end
  end

  context "when finding the next player to play a card" do
    before {
      ApplyOperation.new(
        state,
        Operation.pick_trump.create!(player_id: state.dealer.id,
                                     suit: :hearts),
      ).call
    }

    let(:first_player) { state.player_left_of(state.dealer) }
    let(:second_player) { state.player_left_of(first_player) }

    context "at the start of the first round" do
      it { is_expected.to eq first_player }
    end

    context "after the first player" do
      before {
        card = first_player.hand.first
        ApplyOperation.new(
          state,
          Operation.play_card.create!(
            player_id: first_player.id,
            suit: card.suit,
            rank: card.rank,
          )
        ).call
      }

      it { is_expected.to eq second_player }

      context "after the trick finishes" do
        before {
          card = second_player.hand.first

          ApplyOperation.new(
            state,
            Operation.play_card.create!(
              player_id: second_player.id,
              suit: card.suit,
              rank: card.rank,
            )
          ).call
        }

        it { is_expected.to eq state.trick_winners.last }
      end
    end
  end

end
