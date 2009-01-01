class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string    :name
      t.integer   :pipeline_id
      t.integer   :position
      
      t.string    :task_type

      t.timestamp :started_at
      t.timestamp :finished_at
      t.string    :status

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
