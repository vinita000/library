class UserMailer < ApplicationMailer
    def approve_student_status(student_mail)
        mail(to: student_mail, subject: "Student Approval") 
    end

    def approve_student_book(student_mail,book_taken_from,book_taken_to )
      @book_taken_from = book_taken_from
      @book_taken_to = leave_taken_to

        mail(to: student_mail, subject: "Book Approval") 
    end
     
    def decline_student_book(student_mail,book_taken_from,book_taken_to )
      @book_taken_from = book_taken_from
      @book_taken_to = book_taken_to

        mail(to: student_mail, subject: "Book Declienation") 
    end
end
