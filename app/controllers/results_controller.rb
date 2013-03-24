class ResultsController < ApplicationController
  def new
    @result = Result.new
  end

  def create
    @result = Result.new(params[:result])
    @student = student(params[:result]["matric_no"].downcase).id
    @result[:student_id] = @student.id
      if @result.save
      redirect_to(root_url, :notice => 'Result has been posted successfully')
      StudentMailer.result_email(@student).deliver 
      begin
        #Sms.execute(@student.phone_number, "#{@student.name}, your results have been sent to your email")
      rescue => e
        Rail.logger.info e.backtrace
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
