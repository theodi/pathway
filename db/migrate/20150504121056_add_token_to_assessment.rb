class AddTokenToAssessment < ActiveRecord::Migration
  def up
    add_column :assessments, :token, :string
    Assessment.where("completion_date is not null").each do |assessment|
      assessment.generate_share_token
      assessment.save
    end
  end
  
  def down
    remove_column :assessments, :token
  end
end
