class User < ActiveRecord::Base
  has_many :players, dependent: :destroy

  validates :name, presence: true, length: { minimum: 1 }

  scope :ai, -> { where(ai: true) }
  scope :human, -> { where(ai: false) }

  def ai?; ai; end
  def human?; !ai; end
end
