class User < ActiveRecord::Base

  scope :ai, -> { where(ai: true) }
  scope :human, -> { where(ai: false) }

  def ai?; ai; end
  def human?; !ai; end
end
