require_relative '../../app/models/action'

describe Action do

  describe "#card" do
    context "when the action is passing a trump suit" do
      let(:action) {
        Action.create!(action_type: :pass_trump,
                       suit: :diamonds)
      }

      it "should not have an associated card" do
        expect { action.card }.to raise_error(RuntimeError)
      end

    end

    context "when the action is playing a card" do
      let(:action) {
        Action.create!(action_type: :play_card,
                       suit: :hearts, value: 10)
      }

      it "should have an associated card" do
        expect(action.card).to be_a(Card)
      end
    end

    context "when the card is being dealt" do
      let(:action) {
        Action.create!(action_type: :deal_card,
                       suit: :spades, value: 11)
      }

      it "should have an associated card" do
        expect(action.card).to be_a(Card)
      end
    end
  end
end
