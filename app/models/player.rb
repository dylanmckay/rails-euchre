class Player < ActiveRecord::Base
  has_many :operations
  belongs_to :game
end
