class CreateTaskMessages < ActiveRecord::Migration
  def self.up
    create_table :task_messages do |t|
      t.integer   :task_run_id
      t.text      :message
      t.timestamps
    end
  end

  def self.down
    drop_table :task_messages
  end
end
