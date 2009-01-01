class TaskMessage < ActiveRecord::Base
  belongs_to :task
  
  validates_presence_of :message
end
