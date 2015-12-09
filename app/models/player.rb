class Player < ActiveRecord::Base
  has_many :operations, dependent: :destroy
  belongs_to :game
end
