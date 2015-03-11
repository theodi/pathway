class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organisation
  has_many :assessments, dependent: :destroy

  validates :organisation_id, uniqueness: true, unless: "organisation_id.nil?"

  def associated_organisation=(title)
    org = Organisation.where(title: title).first_or_create
    self.organisation = org
  end

  def associated_organisation
    self.organisation
  end

end
