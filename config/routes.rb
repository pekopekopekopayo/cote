Rails.application.routes.draw do
  resources :users, only: [ :create ]
  scope "customer/:current_user_id", module: :customer_resources do
    resources :exams, only: [ :index ]
    resources :exam_schedules, only: [ :index, :create, :destroy ]
  end

  scope "admin/:current_user_id", module: :admin_resources do
    resources :exams, only: [ :index, :create ]
    resources :exam_schedules, only: [ :index ] do
      member do
        post :approve
        post :reject
      end
    end
  end
end
