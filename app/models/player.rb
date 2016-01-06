class Player < ActiveRecord::Base
  has_many :operations, dependent: :destroy
  belongs_to :game
  belongs_to :user

  INITIAL_CARD_COUNT = 5
  DEALER_DISCARD_CARD_COUNT = INITIAL_CARD_COUNT + 1
end
