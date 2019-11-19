class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:is_librarian]
  before_action :is_librarian , only: [:index,:new_students_list]

  
  def index
     @users = User.where.not(designation: "librarian").all
  end

 
  def show
  end

  
  def new
    @user = User.new
  end

  
  def edit
  end

  
  def create
    @user = User.new(user_params)

      if @user.save
        
        
      else
        render :new 
     end
  end

  
  def update
      if @user.update(user_params)
        redirect_to @user, notice: 'User was successfully updated.' 
      else
       render :edit 
      end
  end

 
  def destroy
    @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.' 
  end

  def is_librarian
    if user_signed_in?
    user_details_obj = User.select(:designation).where(id:current_user.id)
    user_designation = user_details_obj[0].designation
    if user_designation != "librarian"
      redirect_to leaves_path , notice: 'Access Denied.'
    end
  else
    redirect_to root_path, notice: 'Please Sign In Before Access.'
  end    
  end

  def new_students_list
     @new_students = User.where.not(designation:"librarian").where(status:"inactive")
  end

  def all_students_books_list
    
    @all_students_books = Book.all  
  end

  def approve_students_books
    student_id = params[:id] if params[:id].present?
    book_taken_from = params[:book_from] if params[:book_from].present?
    book_taken_to = params[:book_to] if params[:book_to].present?
    student_details = User.where(id: student_id.to_i)
    student_email = student_details[0].email
    UserMailer.approve_student_book(student_email,book_taken_from,book_taken_to).deliver_now
    Book.where(user_id:student_id.to_i).where(book_to:book_taken_to).where(book_from:book_taken_from).update(status:"approved")
    redirect_to users_path
    
  end

  def decline_students_books
    student_id = params[:id] if params[:id].present?
    book_taken_from = params[:book_from].to_s if params[:book_from].present?
    book_taken_to = params[:book_to].to_s if params[:book_to].present?
    puts @book_taken_from.to_json
   
    
    student_details = User.where(id: student_id.to_i)
    student_email = student_details[0].email
    UserMailer.decline_student_book(student_email,book_taken_from,book_taken_to).deliver_now
    Book.where(user_id:student_id.to_i).where(book_to:book_taken_to).where(book_from:book_taken_from).update(status:"declined")
    redirect_to users_path
    
  end
  

  def activate_students_status
      student_id = params[:id] if params[:id].present?
      student_details = User.where(id: student_id.to_i)
      student_email = student_details[0].email
      UserMailer.approve_student_status(student_email).deliver_now
      User.where(id:student_id.to_i).update(status:"active")
      redirect_to users_path
      
  end

  

  
  def new_leaves
    @new_leaves = Leave.where(status:"onhold")
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.fetch(:user, {}).permit(:email, :name, :designation,:password, :current_password)
    end
end
