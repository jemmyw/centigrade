class Pipeline < ActiveRecord::Base
  belongs_to :project
  has_many :tasks

  def execute
    tasks_to_execute = tasks.dup

    while task = tasks_to_execute.shift
      executer = task.execute
      executer.execute

      if executer.status == TaskStatus::WAIT
        tasks_to_execute.unshift(task)
        sleep(1)
      elsif executer.status == TaskStatus::FAILED
        break
      end
    end
  end
end
