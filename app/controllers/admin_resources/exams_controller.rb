class AdminResources::ExamsController < AdminResources::BaseController
  def index
    render json: Exam.all.page(params[:page])
  end

  def create
    Exam.create!(create_params)

    head :created
  end

  private

  def create_params
    params.permit(:name, :start_at)
  end
end
