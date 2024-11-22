class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :current_user
  helper_method :current_user

  rescue_from BadRequestError, with: :render_bad_request_error
  rescue_from ActiveRecord::RecordInvalid, with: :render_bad_request_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ValidationError, with: :render_validation_error

  def current_user
    @current_user ||= User.find(params[:current_user_id])
  end

  private

  def render_validation_error(e)
    render json: { errors: e.errors }, status: :unprocessable_entity
  end

  def render_not_found
    head :not_found
  end

  def render_bad_request_error
    head :bad_request
  end
end
