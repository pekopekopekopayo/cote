class AdminResources::BaseController < ApplicationController
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    head :not_found unless current_user.admin?
  end
end
