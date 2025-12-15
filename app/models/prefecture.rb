class Prefecture < ApplicationRecord
  include CloudfrontUrlConvertible

  has_many :trips, dependent: :destroy

  validates :name, presence: true
  validates :image_path, presence: true

  # S3 URLをCloudFront URLに変換して返す
  def image_path
    convert_to_cloudfront_url(super)
  end
end
