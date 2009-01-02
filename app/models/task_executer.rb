class TaskExecuter
  def initialize(task)
    @task = task
  end

  def execute
    @options = @task.options_as_hash
    @task_object = @task.task_type_class.new(@task.pipeline.project.path, @options)
    @task_object.execute
  end

  def status
    @task_object.status
  end

  def message
    @task_object.message
  end
end