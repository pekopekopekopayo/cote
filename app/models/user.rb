class User < ApplicationRecord
  has_many :exam_schedules
  has_many :exams, through: :exam_schedules

  enum :role, { customer: 0, admin: 1 }

  validates :name, presence: true
end
