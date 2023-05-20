class User < ApplicationRecord
  has_many :trips, dependent: :destroy

  validates :uid, presence: true
  validates :name, presence: true
  validates :icon_path, presence: true
  validates :request_count, presence: true
end
