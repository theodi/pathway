class Improvement < ActiveRecord::Base
  belongs_to :answer
  
  validates :code, presence: true   
  validates :code, uniqueness: true
  validates :notes, presence: true
end
