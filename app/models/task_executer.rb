class TaskExecuter
  def initialize(task)
    @task = task
  end

  def execute
    @options = @task.options_as_hash
    @task_klass = Kernel.const_get(@task.task_type)
    @task_object = @task_klass.new(@options)
    @task_object.execute(@task.pipeline.project, @task)
  end

  def status
    TaskStatus::FAILED
  end

  def message
    ''
  end
end