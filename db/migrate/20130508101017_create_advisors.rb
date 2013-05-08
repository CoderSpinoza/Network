class CreateAdvisors < ActiveRecord::Migration
  def change
    create_table :advisors do |t|
    	t.string :first_name
    	t.string :last_name
    	t.string :contact
    	t.string :email
    	t.string :university
      t.string :country
      t.string :city
      t.string :state
    	t.string :department
    	t.string :position
      t.string :theme
      t.string :subtheme
    	t.string :keywords
      t.string :notes
      t.string :alma_mater
      t.string :graduate_degree
      t.integer :num_of_publications
      t.string :code
      t.timestamps
    end
    add_index :advisors, :code, :unique => true
  end
end
