class User < ApplicationRecord
  include CloudfrontUrlConvertible

  has_many :trips, dependent: :destroy

  validates :uid, presence: true
  validates :name, presence: true, length: { maximum: 20 }
  validates :icon_path, presence: true

  # S3 URLをCloudFront URLに変換して返す
  def icon_path
    convert_to_cloudfront_url(super)
  end
end
