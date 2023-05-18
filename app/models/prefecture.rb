class Prefecture < ApplicationRecord
  validates :name, presence: true
  validates :image_path, presence: true
end
