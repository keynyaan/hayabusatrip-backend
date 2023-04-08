class User < ApplicationRecord
  validates :uid, presence: true
end
