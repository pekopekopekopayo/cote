class UsersController < ApplicationController
  skip_before_action :current_user

  def create
    User.create!(create_params)

    head :created
  end

  private

  def create_params
    params.permit(:name)
  end
end
