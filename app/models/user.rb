class User < ActiveRecord::Base
  has_many :players, dependent: :destroy

  validates :name, presence: true

  scope :ai, -> { where(ai: true) }
  scope :human, -> { where(ai: false) }

  def human?
    !ai
  end
end
