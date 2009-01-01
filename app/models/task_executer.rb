class TaskExecuter
  def initialize(task)
    @task = task
  end

  def execute
  end

  def status
    TaskStatus::FAILED
  end

  def message
    ''
  end
end