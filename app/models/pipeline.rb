class Pipeline < ActiveRecord::Base
  belongs_to :project
  has_many :tasks, :order => 'position'

  def execute
    tasks_to_execute = tasks.dup

    while task = tasks_to_execute.shift
      puts "Found next task: %s" % task.name

      executer = task.execute

      puts "Task finished with status %s" % executer.status

      if executer.status == TaskStatus::WAIT
        puts "Waiting to execute task again"
        tasks_to_execute.unshift(task)
        sleep(30)
      elsif executer.status == TaskStatus::FAILED
        puts "Exiting due to failure"
        break
      end
    end
  end
end
