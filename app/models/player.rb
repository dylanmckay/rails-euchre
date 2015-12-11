class Player < ActiveRecord::Base
  has_many :operations, dependent: :destroy
  belongs_to :game
  belongs_to :user

  def ai?; user.ai; end
  def human?; !user.ai; end

  def ==(other)
    if other.is_a?(Player) || other.is_a?(PlayerState)
      id == other.id
    else
      false
    end
  end
end
