require 'centigrade_log'

class TaskExecuter
  include Centigrade::Log

  def initialize(task)
    @task = task
  end

  def execute
    logger.info "Executing task %s:" % @task.name

    @options = @task.options_as_hash
    @task_object = @task.task_type_instance

    @task_run = TaskRun.create(:status => 'running')
    @task.runs << @task_run

    begin
      @task_object.execute

      messages.each do |message|
        @task_run.messages.create(:message => message)
      end

      @task_run.status = status
      @task_run.save
    rescue Exception => e
      @task_run.update_attribute(:status, TaskStatus::FAILED)
    end

    logger.info "Task %s finished with status %s" % [@task.name, self.status]
  end

  def status
    @task_object.status
  end

  def messages
    @task_object.messages
  end
end