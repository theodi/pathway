class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organisation
  has_many :assessments, dependent: :destroy

  validates :organisation_id, uniqueness: true, unless: "organisation_id.nil?"
  validates :name, presence: true
  validates :terms_of_service, acceptance: true
  
  def self.can_share?(user, assessment)
    return true if (user.present? && user.id == assessment.user.id)
  end
  
  def self.organisational_users
    return User.where("organisation_id is not null")
  end
  
  def current_assessment
    assessments.where(:completion_date => nil).first
  end

  def associated_organisation=(title)
    org = Organisation.where(title: title).first_or_create
    self.organisation = org
  end

  def associated_organisation
    self.organisation
  end

  def latest_completed_assessment
    return assessments.where("completion_date is not null").order(completion_date: :desc).first
  end
end
