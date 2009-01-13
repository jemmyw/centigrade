class TaskMessage < ActiveRecord::Base
  belongs_to :task_run
  
  validates_presence_of :message
end
