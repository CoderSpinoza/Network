class Relationship < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :mentor, :class_name => "Advisor"
  belongs_to :student, :class_name => "Advisor"
  attr_accessible :mentor, :student, :mentor_id, :student_id

  validates :mentor_id, :uniqueness => { :scope => :student_id }
end
