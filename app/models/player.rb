class Player < ActiveRecord::Base
  has_many :operations, dependent: :destroy
  belongs_to :game
  belongs_to :user

  def ai?; user.ai; end
  def human?; !user.ai; end
end
