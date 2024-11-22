class ExamSchedule < ApplicationRecord
  belongs_to :exam
  belongs_to :user

  enum :status, {
    reserved: 0,
    approved: 1
  }
end
