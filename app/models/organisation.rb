class Organisation < ActiveRecord::Base

  has_many :users
  has_many :statistics, class_name: "OrganisationScore"
  
  validates :title, presence: true
  validates :title, uniqueness: true

  before_save :set_name

  def self.dgu
    Organisation.where("dgu_id is not null")
  end
    
  def self.all_organisations_group
    Organisation.find_by_title("All Organisations")
  end
  
  def self.all_dgu_organisations_group
    Organisation.find_by_title("All data.gov.uk organisations")
  end
  
  def to_s
    self.title
  end

  def as_json(options)
    { id: title, text: title }
  end
  
  def set_name
    self.name = self.title.parameterize if self.name.blank?
  end

  def parent?
    Organisation.where(parent: self.id).present?
  end
  
  def dgu_organisation?
    return dgu_id.present?
  end
  
  def latest_completed_assessment
    user = users.first
    return nil unless user.present?
    return user.latest_completed_assessment
  end  
  
end
