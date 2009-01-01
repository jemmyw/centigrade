class CreateTaskMessages < ActiveRecord::Migration
  def self.up
    create_table :task_messages do |t|
      t.integer   :task_id
      t.string    :status
      t.text      :message
      t.timestamps
    end
  end

  def self.down
    drop_table :task_messages
  end
end
