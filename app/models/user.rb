class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organisation

  validates :organisation_id, uniqueness: true, unless: "organisation_id.nil?"

  def associated_organisation=(name)
    org = Organisation.where(name: name).first_or_create
    self.organisation = org
  end

  def associated_organisation
    self.organisation
  end

end
