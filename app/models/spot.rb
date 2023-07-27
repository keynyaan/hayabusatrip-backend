class Spot < ApplicationRecord
  belongs_to :trip

  validates :category, :name, :date, :start_time, :end_time, :cost, presence: true
  validates :name, length: { maximum: 30 }
  validates :cost, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 99999999 }
  validates :memo, length: { maximum: 50 }
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "終了時間は開始時間の後に設定してください。")
    end
  end
end
