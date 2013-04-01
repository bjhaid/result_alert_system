class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:session][:matric_no].nil? || params[:session][:matric_no].empty?
      redirect_to register_path, :alert =>"Please enter a valid Matric No, or Register"
    else
      student = Student.find_by_matric_no(params[:session][:matric_no].downcase)
      if student && student.authenticate(params[:session][:password])
        session[:student_id] = student.id
        redirect_to profile_path, :notice => "Logged in!"
      else
        redirect_to root_url, :alert =>"Invalid Matric No or Password"
      end
    end
  end

  def show
  end

  def destroy
    session[:student_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
