class WaitForTask < CentigradeTask::Base
  attribute :task_id, :required => true

  def execute!
    @task = Task.find(self.task_id)

    if !@task.finished_at
      status(TaskStatus::WAIT) and return
    end

    if data[:finished_at].nil? || data[:finished_at] < @task.finished_at
      status(TaskStatus::SUCCESS)
      data[:finished_at] = @task.finished_at
    else
      status(TaskStatus::WAIT)
    end
  end
end