class TaskOption < ActiveRecord::Base
  belongs_to :task
  validates_presence_of :name
end
