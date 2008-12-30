class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string    :name
      t.integer   :pipeline_id
      t.integer   :position
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
