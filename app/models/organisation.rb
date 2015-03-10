class Organisation < ActiveRecord::Base

  validates :title, presence: true
  validates :title, uniqueness: true

  def to_s
    self.title
  end

  def as_json(options)
    { id: title, text: title }
  end

end
