class Spot < ApplicationRecord
  belongs_to :trip

  validates :spot_icon, :title, :date, :start_time, :end_time, :cost, presence: true
  validates :title, length: { maximum: 30 }
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "終了時間は開始時間の後に設定してください。")
    end
  end
end
