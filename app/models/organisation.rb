class Organisation < ActiveRecord::Base

  validates :title, presence: true
  validates :title, uniqueness: true

  def to_s
    self.title
  end

end
