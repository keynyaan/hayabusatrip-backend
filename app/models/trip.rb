class Trip < ApplicationRecord
  has_many :spots, dependent: :destroy
  belongs_to :user
  belongs_to :prefecture

  validates :title, :start_date, :end_date, :image_path, :trip_token, presence: true
  validates :title, length: { maximum: 30 }
  validates :memo, length: { maximum: 1000 }
  validates :is_public, inclusion: { in: [true, false] }
  validates :trip_token, uniqueness: true
  validate :start_date_within_range
  validate :end_date_within_range

  private

  def start_date_within_range
    return if start_date.blank?

    if start_date < Date.new(2000, 1, 1) || start_date > Date.new(9999, 12, 31)
      errors.add(:start_date, "開始日は2000年1月1日から9999年12月31日の間の日付を入力してください")
    end
  end

  def end_date_within_range
    return if end_date.blank? || start_date.blank?

    if end_date < Date.new(2000, 1, 1) || end_date > Date.new(9999, 12, 31)
      errors.add(:end_date, "終了日は2000年1月1日から9999年12月31日の間の日付を入力してください")
    end

    if end_date < start_date
      errors.add(:end_date, "終了日は開始日の後に設定してください。")
    elsif (end_date - start_date).to_i > 9
      errors.add(:end_date, "終了日は開始日から10日以内に設定してください。")
    end
  end
end
