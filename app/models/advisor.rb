class Advisor < ActiveRecord::Base
  # attr_accessible :title, :body
  require 'CSV'
  default_scope order('last_name ASC')

  has_many :relationships, :class_name => "Relationship", :foreign_key => "mentor_id"
  has_many :inverse_relationships, :class_name => "Relationship", :foreign_key => "student_id"
  has_many :mentors, :through => :inverse_relationships, :source => :mentor
  has_many :students, :through => :relationships, :source => :student
  attr_accessible :first_name, :last_name, :contact, :email, :university, :country, :city, :state, :department, :position, :theme, :subtheme, :keywords, :notes, :alma_mater, :graduate_degree, :num_of_publications, :code

  validates :first_name, :presence => true, :length => { :minimum => 2, :maximum => 50 }
  validates :last_name, :presence => true, :length => { :minimum => 2, :maximum => 50 }

  def self.import(file)
    Advisor.destroy_all
    Relationship.destroy_all
    csv = CSV.read(file.path, 'r:ISO-8859-1')
  	# CSV.foreach(file.path, { headers: true, :enconding => "r:ISO-8859-1" }) do |row|    
    #    Advisor.create(:first_name => row[5], :last_name => row[4])
    #  end

    Advisor.create(:first_name => "Samsung", :last_name => "SISA")
    csv.drop(1).each do |row|
      advisor = Advisor.create(:first_name => row[5], :last_name => row[4], :contact => row[8], :email => row[9], :university => row[12], :country => row[13], :city => row[14], :department => row[15], :position => row[16], :theme => row[17], :subtheme => row[18], :keywords => row[21], :alma_mater => row[24], :graduate_degree => row[25], :num_of_publications => row[27], :code => row[2])
    end

    cores = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]

    for core in cores
      core_code = core + "1"
      core_advisor = Advisor.find_by_code(core_code)
      Relationship.create(:mentor_id => "1", :student_id => core_advisor.id)
    end

    csv.drop(1).each do |row|

      advisor = Advisor.find_by_code(row[2])
      collaborators = row[10]
      if collaborators
        collaborators = collaborators.split(',').collect{|code| code.strip}

        for collaborator_code in collaborators
          collaborator = Advisor.find_by_code(collaborator_code)
          if collaborator
            Relationship.find_or_create_by_mentor_id_and_student_id(collaborator.id, advisor.id)
            Relationship.find_or_create_by_mentor_id_and_student_id(advisor.id, collaborator.id)
          end
        end
      end

      advisors = row[11]
      if advisors
        advisors = advisors.split(',').collect{|code| code.strip}

        for mentor_code in advisors
          mentor = Advisor.find_by_code(mentor_code)
          if mentor
            Relationship.find_or_create_by_mentor_id_and_student_id(mentor.id, advisor.id)
          end
        end
      end
    end

# , :university => row[12], :country => row[13], :city => row[14], :state => row[15], :department => row[16], :position => row[17], :theme => row[18], :subtheme => row[19], :keywords => row[22], :alma_mater => row[25], :graduate_degree => row[26], :num_of_publications => row[28]
  end

  def self.full_names
    advisor_names = []
    Advisor.all.each { |advisor| advisor_names << advisor.fullname }
    return advisor_names
  end


  def self.first_names
    first_names = []
    Advisor.all.each { |advisor| first_names << advisor.first_name }
    return first_names
  end

  def self.last_names
    last_names = []
    Advisor.all.each { |advisor| last_names << advisor.last_name }
    return last_names
  end

  def fullname
    "#{first_name} #{last_name}"
  end
end
