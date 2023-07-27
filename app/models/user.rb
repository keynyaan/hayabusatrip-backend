class User < ApplicationRecord
  has_many :trips, dependent: :destroy

  validates :uid, presence: true
  validates :name, presence: true, length: { maximum: 20 }
  validates :icon_path, presence: true
end
