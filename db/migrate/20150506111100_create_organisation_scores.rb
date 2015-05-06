class CreateOrganisationScores < ActiveRecord::Migration
  def up
    Organisation.create!(title: "All Organisations")
    Organisation.create!(title: "All data.gov.uk organisations")
    
    create_table :organisation_scores do |t|
      t.integer :organisation_id
      t.integer :activity_id
      t.integer :initial
      t.integer :repeatable
      t.integer :defined
      t.integer :managed
      t.integer :optimising

      t.timestamps null: false
    end
  end
  
  def down
    drop_table :organisation_scores
    Organisation.all_organisations_group.delete
    Organisation.all_dgu_organisations_group.delete
  end
end
