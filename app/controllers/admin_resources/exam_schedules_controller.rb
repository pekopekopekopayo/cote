class AdminResources::ExamSchedulesController < AdminResources::BaseController
  def index
    render json: ExamSchedule.where(exam_id: params[:exam_id]).all.page(params[:page])
  end

  def approve
    ActiveRecord::Base.transaction do
      exam_schedule = ExamSchedule.reserved.find(params[:id]).lock
      exam = exam_schedule.exam.lock

      raise ValidationError, [ { type: :fully_booked } ] if exam.fully_booked?

      exam_schedule.approved!
      exam.increment!(:booked_count)
    end

    head :ok
  end

  def reject
    ActiveRecord::Base.transaction do
      exam_schedule = ExamSchedule.approved.find(params[:id]).lock
      exam = exam_schedule.exam.lock
      exam_schedule.destroy!
      exam.decrement!(:booked_count)
    end

    head :ok
  end

  private

  def create_params
    params.permit(:name, :start_at)
  end
end
