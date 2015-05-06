class OrganisationScore < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :activity

  def completed_assessments
    return self.initial + self.defined + self.repeatable + self.managed + self.optimising
  end
  
end
