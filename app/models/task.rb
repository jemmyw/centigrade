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
  has_many :runs, :class_name => 'TaskRun'

  validates_presence_of :name, :pipeline, :task_type

  def validate
    unless task_type_class.respond_to?(:attributes)
      errors.add("task_type", "class must implement attributes method")
    else
      attributes = task_type_class.attributes
      attributes.each do |attribute|
        if attribute[:required] && !options_as_hash.has_key?(attribute[:name].to_s)
          errors.add("options", "does not include required attribute %s" % attribute[:name].to_s)
        end
      end
    end
  end

  def execute
    returning TaskExecuter.new(self) do |executer|
      update_attributes(:finished_at => nil, :started_at => Time.now, :status => TaskStatus::RUNNING)
      
      executer.execute

      update_attributes(:finished_at => Time.now, :status => TaskStatus::WAITING)
    end
  end

  def options_as_hash
    Hash[*options.collect{|option| [option.name, option.value]}.flatten]
  end

  def task_type_instance
    task_type_class.new(self.pipeline.project.path, options_as_hash)
  end

  def task_type_class
    @task_type_class ||= Kernel.const_get(self.task_type) rescue nil
  end

  def last_run
    runs.find(:first, :order => 'created_at DESC')
  end

  def success?
    last_run.andand.status == TaskStatus::SUCCESS
  end
end
