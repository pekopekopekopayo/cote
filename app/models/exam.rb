class Exam < ApplicationRecord
  has_many :exam_schedules
  has_many :users, through: :exam_schedules

  FULLY_BOOKED_THRESHOLD = 50_000
  VALID_DAYS = 3.days

  def fully_booked?
    self.booked_count >= FULLY_BOOKED_THRESHOLD
  end

  def reserveable_time?
    self.start_at.ago(VALID_DAYS).future?
  end
end
