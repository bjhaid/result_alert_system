class StudentsController < ApplicationController
  def new
    @student = Student.new
  end

  def create
    @student = Student.new(params[:student])
    if @student.save
      session[:student_id] = @student.id
      begin
        StudentMailer.welcome_email(@student).deliver 
        Sms.execute(@student.phone_number, "#{@student.name}, you have successfully registered for the UNIABUJA student alert system")
        redirect_to(root_path, :notice => 'Your account has been created')
      rescue Net::SMTPAuthenticationError => e1
        Rails.logger.info e1.backtrace
        redirect_to(root_path, :notice => 'Your account has been created, however there was error sending email')
      rescue => e
        Rails.logger.info e.backtrace
        redirect_to(root_path, :notice => 'Your account has been created, however there was error sending sms')
      end
    else
      Rails.logger.info @student.errors.messages.inspect
      redirect_to(register_path, :alert => @student.errors)
    end
  end

  def show
  end
end
