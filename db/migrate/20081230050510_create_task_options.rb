class CreateTaskOptions < ActiveRecord::Migration
  def self.up
    create_table :task_options do |t|
      t.integer   :task_id
      t.string    :name
      t.text    :value
      t.timestamps
    end
  end

  def self.down
    drop_table :task_options
  end
end
