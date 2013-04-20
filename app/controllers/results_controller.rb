class ResultsController < ApplicationController
  def new
    @result = Result.new
  end

  def create
    @result = Result.new(params[:result])
    @student = student(params[:result]["matric_no"].downcase)
    if @student.nil?
      redirect_to(result_path, :notice => "Student Matric number not found")
    else
      @result[:student_id] = @student.id
    end

    if @result.save
      redirect_to(root_path, :notice => 'Result has been posted successfully')
      begin
        StudentMailer.result_email(@student).deliver 
        Sms.execute(@student.phone_number, "You scored #{@result.score} in #{@result.course_title} #{@result.course_name}")
      rescue Net::SMTPAuthenticationError => e1
        Rails.logger.info e1.backtrace
        redirect_to(root_path, :notice => 'Result has been posted, however there was error sending email')
      rescue => e
        Rails.logger.info e.backtrace
        redirect_to(root_path, :notice => 'Result has been posted, however there was error sending sms')
      end
    else
      redirect_to(result_path, :alert => @result.errors)
    end
  end

  def show
  end

  private
  def student(matric_no)
    student = Student.find_by_matric_no(matric_no)
    student.nil? ? nil : student
  end
end
