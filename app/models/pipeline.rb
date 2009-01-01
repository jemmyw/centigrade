class Pipeline < ActiveRecord::Base
  belongs_to :project
  has_many :tasks

  def execute
    tasks.each do |task|
      executer = task.execute
      executer.execute
      
      if executer.status != TaskStatus::SUCCESS
        break
      end
    end
  end
end
