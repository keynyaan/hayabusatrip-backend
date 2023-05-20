class Trip < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture

  validates :title, :start_date, :end_date, :image_path, :trip_token, presence: true
  validates :title, length: { maximum: 30 }
  validates :memo, length: { maximum: 1000 }
  validates :is_public, inclusion: { in: [true, false] }
  validate :end_date_within_range

  private

  def end_date_within_range
    return if end_date.nil? || start_date.nil?

    if end_date < start_date
      errors.add(:end_date, "終了日は開始日の後に設定してください。")
    elsif (end_date - start_date).to_i > 10
      errors.add(:end_date, "終了日は開始日から10日以内に設定してください。")
    end
  end
end
