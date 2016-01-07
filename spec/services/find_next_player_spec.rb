describe FindNextPlayer do
  let(:player_models) { create_player_models(3) }

  let(:state) {
    create_custom_game_state({ players: player_models.map{|model| {player_model: model} } })
  }

  subject(:next_player) { FindNextPlayer.new(state).call }

  context "when performing trump selection" do
    context "on the first turn" do
      it { is_expected.to eq state.player_left_of(state.dealer) }
    end

    context "when the dealer passed" do
      before {
        ApplyOperation.new(
          state,
          player_models[0].operations.pass_trump.new
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
          player_models[0].operations.pass_trump.new
        ).call

        ApplyOperation.new(
          state,
          player_models[1].operations.pass_trump.new
        ).call
      }

      it { is_expected.to eq third_player }
    end
  end

  context "when finding the next player to play a card" do
    before {
      ApplyOperation.new(
        state,
        player_models[0].operations.pick_trump.new(suit: :hearts),
      ).call
    }

    let(:first_player) { state.player_left_of(state.dealer) }
    let(:second_player) { state.player_left_of(first_player) }

    let(:player_models) { create_player_models(2) }

    let(:state) {
      create_custom_game_state({players: player_models.map{|model| {player_model: model}}, trump_suit: nil })
    }

    context "at the start of the first round" do
      it { is_expected.to eq first_player }
    end

    context "after the first player" do
      before {
        card = first_player.hand.first
        ApplyOperation.new(
          state,
          player_models[1].operations.play_card.new(
            suit: card.suit,
            rank: card.rank,
          )
        ).call
      }

      it { is_expected.to eq second_player }
    end

    context "after the trick finishes" do
      before {
        card = state.players[1].hand.first
        ApplyOperation.new(
          state,
          player_models[1].operations.play_card.new(
            suit: card.suit,
            rank: card.rank,
          )
        ).call

        card = state.players[0].hand.first

        ApplyOperation.new(
          state,
          player_models[0].operations.play_card.new(
            suit: card.suit,
            rank: card.rank,
          )
        ).call
      }

      it { is_expected.to eq state.players.find{ |p| p.scored_cards.any? } }
    end
  end
end
