class CustomerResources::ExamsController < CustomerResources::BaseController
  def index
    render json: Exam.all.page(params[:page])
  end
end
