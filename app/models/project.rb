class Project < ActiveRecord::Base
  has_many :pipelines
  
  validates_presence_of :name
end
