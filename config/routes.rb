Rails.application.routes.draw do
  devise_for :users

  resources :users, only:[:index] do
    collection do
      get :new_students_list
      post :activate_students_status
      get  :all_students_books_list
      post :approve_students_books
      post :decline_students_books
      get  :new_leaves
    end
  end
  
  resources :books, only:[:new,:create,:index] do
    collection do
      get :error_book
    end
  end


  root :to => redirect("/users/sign_in") # setting employees sign in (device) as root page
  
end
