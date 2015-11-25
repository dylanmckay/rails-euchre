class Player < ActiveRecord::Base
  has_many :actions
  belongs_to :game
end
