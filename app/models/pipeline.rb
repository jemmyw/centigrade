class Pipeline < ActiveRecord::Base
  belongs_to :project
  has_many :tasks, :order => 'position'

  def last_run_at
    (tasks.collect(&:started_at) + tasks.collect(&:finished_at)).sort.last
  end

  def success?
    tasks.all?{|t| t.success? }
  end

  def running?
    tasks.any?{|t| t.status == TaskStatus::RUNNING }
  end

  def execute
    tasks_to_execute = tasks.dup

    while task = tasks_to_execute.shift
      executer = task.execute

      if executer.status == TaskStatus::WAIT
        tasks_to_execute.unshift(task)
        30.times do
          sleep(1)
        end
      elsif executer.status == TaskStatus::FAILED
        break
      end
    end
  end
end
