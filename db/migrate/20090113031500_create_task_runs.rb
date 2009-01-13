class CreateTaskRuns < ActiveRecord::Migration
  def self.up
    create_table :task_runs do |t|
      t.integer     :task_id
      t.text        :status
      t.timestamps
    end
  end

  def self.down
    drop_table :task_runs
  end
end
