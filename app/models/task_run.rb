class TaskRun < ActiveRecord::Base
  belongs_to :task
  has_many :messages, :class_name => 'TaskMessage'
end
