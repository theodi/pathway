class Link < ActiveRecord::Base
  belongs_to :assessment_answer
  validates_format_of :link, :with => URI::regexp(%w(http https))
end
