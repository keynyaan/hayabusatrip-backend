class Prefecture < ApplicationRecord
  has_many :trips, dependent: :destroy

  validates :name, presence: true
  validates :image_path, presence: true
end
