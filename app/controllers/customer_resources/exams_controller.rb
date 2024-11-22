class CustomerResources::ExamsController < CustomerResources::BaseController
  def index
    exams = Exam.all.page(params[:page])

    render  json: exams
  end
end
