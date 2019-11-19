class BooksController < ApplicationController

    def index
        @books = Book.where(user_id:current_user.id).all
    end

    
    def show
      @book = Book.find(params[:id]) 
    end

    def new
        @book = Book.new
    end


    def edit
      @book = Book.find(params[:id])  
    end
    
    def create
        @book = Book.new((book_params).merge(user_id:current_user.id))

          if @book.save
    
             redirect_to books_path
          else
            flash.now[:error] = "Could not save book"
            render action: "new"
          end
    end


    def update
          if @book.update(book_params)
            redirect_to @book, notice: 'Book was successfully updated.' 
          else
            render :edit 
          end
    end

    def destroy
        @book.destroy
          redirect_to leaves_url, notice: 'Leave was successfully destroyed.'
    
    end
    
    
    def error_leave
    end
    
  
    def students_status_check
        if user_signed_in?
        current_student_obj = User.where(id:current_user.id)
        current_student_status = current_student_obj[0].status
        #current_employee_designation = current_employee_obj[0].designation
        if current_student_status == "active" 
        render 'new'
        else
        redirect_to error_book_books_path
        end
    else
        redirect_to root_path
    end    
    end
    
    private
        
    def set_book
      @book = Book.find(params[:id])
    end
    
    def book_params
       params.fetch(:book, {}).permit(:book_to,:book_from,:comment,:image)
    end
end
        





























