  class Country < ActiveRecord::Base
  has_many :users
  has_many :assessments, through: :users

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :code, presence: true
  validates :code, uniqueness: true

  def to_s
    self.name
  end

  def as_json(options)
    { id: name, text: name }
  end

  def users_with_organisations
      return users.where("organisation_id is not null")
  end
end
