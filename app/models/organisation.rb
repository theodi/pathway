class Organisation < ActiveRecord::Base

  validates :name, :title, :dgu_id, presence: true

end
