class TaskExecuter
  def initialize(task)
    @task = task
  end

  def execute
    @options = @task.options_as_hash
    @task_klass = Kernel.const_get(@task.task_type)
    @task_object = @task_klass.new(@task.pipeline.project.path, @options)
    @task_object.execute
  end

  def status
    @task_object.status
  end

  def message
    @task_object.message
  end
end