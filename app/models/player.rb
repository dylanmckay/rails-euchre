class Player < ActiveRecord::Base
  has_many :operations, dependent: :destroy
  belongs_to :game
  belongs_to :user

  # Remove these methods, use 'user' directly
  def ai?
    user.ai
  end

  def human?
    !user.ai
  end

  # TODO: don't mess with ActiveRecord operatprs
  # player state stuff is bad too
  def ==(other)
    if other.is_a?(Player) || other.is_a?(PlayerState)
      id == other.id
    else
      false
    end
  end
end
