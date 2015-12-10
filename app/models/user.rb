class User < ActiveRecord::Base

  scope :ai, -> { where(ai: true) }
  scope :human, -> { where(ai: false) }
end
