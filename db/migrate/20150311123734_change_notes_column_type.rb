class ChangeNotesColumnType < ActiveRecord::Migration
  def change
    change_column :assessments, :notes, :text
  end
end
