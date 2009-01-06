class TaskExecuter
  def initialize(task)
    @task = task
  end

  def execute
    $stdout.write "\nExecuting task %s:" % @task.name

    @options = @task.options_as_hash
    @task_object = @task.task_type_class.new(@task.pipeline.project.path, @options)

    returning @task_object.execute do |e|
      $stdout.write "\t\t\t[%s]" % self.status
    end
  end

  def status
    @task_object.status
  end

  def message
    @task_object.message
  end
end