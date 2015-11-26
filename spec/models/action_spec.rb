require_relative '../../app/models/action'

describe Action do

  describe "#card" do
    context "when the action is passing a trump suit" do
      let(:action) {
        Action.create!(action_type: Action::PASS_TRUMP,
                       suit: "DIAMONDS")
      }

      it "should not have an associated card" do
        expect { action.card }.to raise_error(RuntimeError)
      end

    end

    context "when the action is playing a card" do
      let(:action) {
        Action.create!(action_type: Action::PLAY_CARD,
                       suit: "HEARTS", value: 10)
      }

      it "should have an associated card" do
        expect(action.card).to be_a(Card)
      end
    end
  end
end
