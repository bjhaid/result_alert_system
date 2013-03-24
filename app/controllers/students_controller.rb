class StudentsController < ApplicationController
  def new
    @student = Student.new
  end

  def create
    @student = Student.new(params[:student])
    if @student.save
      redirect_to(root_url, :notice => 'Your account has been created')
      StudentMailer.welcome_email(@student).deliver 
      begin
        #Sms.execute(@student.phone_number, "#{@student.name}, you have successfully registered for the UNIABUJA student alert system")
      rescue => e
        Rail.logger.info e.backtrace
      end
    else
      Rails.logger.info @student.errors.messages.inspect
      redirect_to(register_path, :alert => @student.errors)
    end
  end

  def show
  end
end