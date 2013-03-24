class Result < ActiveRecord::Base
  belongs_to :student
  attr_accessor :matric_no, :student_id
  attr_accessible :course_name, :course_title, :matric_no, :student_id, :score
  validates_presence_of :course_name, :course_title, :matric_no, :score
  validate :id_by_matric_number?

  def student
    Student.find_by_matric_no(matric_no)
  end

  def id_by_matric_number?
    if student.nil?
      errors.add(:matric_no, "no record of the matric number found")
    else
      student_id = student.id 
    end
  end
end
