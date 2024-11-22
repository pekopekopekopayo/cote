class CustomerResources::ExamSchedulesController < CustomerResources::BaseController
  def index
    @exams = current_user.exams.page(params[:page])
  end

  def create
    exam = Exam.find(params[:exam_id])

    raise ValidationError, [ { type: :not_reserveable_time } ] unless exam.reserveable_time?
    raise ValidationError, [ { type: :fully_booked } ] if exam.fully_booked?
    raise ValidationError, [ { type: :already_reserved } ] if current_user.exam_schedules.where(exam_id: exam.id).exists?

    current_user.exam_schedules.create!(exam_id: exam.id)

    head :created
  end

  def destroy
    current_user.exam_schedules.reserved.find(params[:id]).destroy!

    head :no_content
  end
end
