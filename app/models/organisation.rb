class Organisation < ActiveRecord::Base

  validates :title, presence: true
  validates :title, uniqueness: true

  before_save :set_name

  def to_s
    self.title
  end

  def as_json(options)
    { id: title, text: title }
  end
  
  def set_name
    self.name = self.title.parameterize if self.name.blank?
  end

end
