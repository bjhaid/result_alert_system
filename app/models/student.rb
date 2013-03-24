class Student < ActiveRecord::Base
  has_many :results
  attr_accessible :email, :matric_no, :name, :phone_number
  validates_presence_of :email, :matric_no, :name, :phone_number
  validates_uniqueness_of :matric_no  
  validates :email, :format => { :with => %r{.+@.+\..+}, :message => "is not a valid email address" }
  validates :phone_number, :format => { :with => %r{0\d{10}}, :message => "it should be of the format 08030000001" }

  def matric_no=(value)
    value.downcase
    self[:matric_no] = value
  end
end
