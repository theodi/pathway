class Assessment < ActiveRecord::Base
  belongs_to :user
  has_many :assessment_answer, dependent: :destroy

  def self.completed
    where.not(completion_date: nil)
  end

  def status
    if start_date.blank?
      "Not started"
    elsif completion_date.blank?
      "Incomplete"
    else
      "Completed"
    end 
  end
end
