class StudentMailer < ActionMailer::Base
  default from: "info@resultalets.com"

  def welcome_email(student)
    @student = student
    mail(:to => student.email, :subject => "Welcome to Result Alert System")
  end

  def result_email(student)
    @student = student
    @results = student.results
    mail(:to => student.email, :subject => "Alerts: #{student.name} Your Latest Results")
  end
end
