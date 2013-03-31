class ResultsController < ApplicationController
  def new
    @result = Result.new
  end

  def create
    @result = Result.new(params[:result])
    @student = student(params[:result]["matric_no"].downcase)
    @result[:student_id] = @student.empty? ? "" : @student.id
    if @result.save
      redirect_to(root_path, :notice => 'Result has been posted successfully')
      begin
        StudentMailer.result_email(@student).deliver 
        Sms.execute(@student.phone_number, "#{@student.name}, your results have been sent to your email")
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
    student.nil? ? "" : student
  end
end
