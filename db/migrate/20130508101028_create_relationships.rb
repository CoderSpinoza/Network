class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
    	t.references :mentor
    	t.references :student
      t.timestamps
    end

    add_index :relationships, [:mentor_id, :student_id], :unique => true
  end
end
