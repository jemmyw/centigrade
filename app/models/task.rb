require 'ostruct'

module TaskStatus
  SUCCESS = 'success'
  FAILED  = 'failed'
  WAIT    = 'wait'
  WAITING = 'waiting'
  RUNNING = 'running'
end

class Task < ActiveRecord::Base
  belongs_to :pipeline
  acts_as_list :scope => :pipeline

  has_many :options,  :class_name => "TaskOption"
  has_many :messages, :class_name => 'TaskMessage'

  validates_presence_of :name, :pipeline

  def execute
    returning TaskExecuter.new(self) do |executer|
      update_attributes(:finished_at => nil, :started_at => Time.now, :status => TaskStatus::RUNNING)
      
      executer.execute

      messages.build(:status => executer.status, :message => executer.message)
      update_attributes(:finished_at => Time.now, :status => TaskStatus::WAITING)
    end
  end

  def options_as_hash
    Hash[*options.collect{|option| [option.name, option.value]}.flatten]
  end

  def task_type_class
    @task_type_class ||= Kernel.const_get(self.task_type) rescue nil
  end
end
