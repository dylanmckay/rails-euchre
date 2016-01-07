RSpec.describe CalculateRoundPoints do
  let(:game_state) {
    create_game_state(player_count: 2)
  }

  subject { CalculateRoundPoints.new(game_state).call }

  context "when neither player has won any tricks" do
    it { is_expected.to eq [0,0] }
  end

  context "when one player has scored 3 tricks and also picked the trump" do
    before {
      award_player_cards(6, game_state.players.first)
      award_player_cards(4, game_state.players.last)
      game_state.trump_state.trump_chooser = game_state.players.first.player
    }

    it { is_expected.to eq [1,0]}
  end

  context "when one player has scored a march and also picked the trump" do
    before {
      award_player_cards(10, game_state.players.first)
      game_state.trump_state.trump_chooser = game_state.players.first.player
    }

    it { is_expected.to eq [2,0]}
  end

  context "when the one player echured the other by scoring 3 tricks" do
    before {
      award_player_cards(6, game_state.players.first)
      award_player_cards(4, game_state.players.last)
      game_state.trump_state.trump_chooser = game_state.players.last.player
    }

    it { is_expected.to eq [3,0]}
  end

  context "when the one player echured the other by scoring a march (5)" do
    before {
      award_player_cards(10, game_state.players.first)
      game_state.trump_state.trump_chooser = game_state.players.last.player
    }

    it { is_expected.to eq [4,0] }
  end

  def award_player_cards(count, player)
    count.times do
      player.scored_cards << create_card
    end
  end
end
