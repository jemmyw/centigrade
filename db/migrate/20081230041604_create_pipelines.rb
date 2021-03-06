class CreatePipelines < ActiveRecord::Migration
  def self.up
    create_table :pipelines do |t|
      t.integer   :project_id
      t.boolean   :running
      t.timestamps
    end
  end

  def self.down
    drop_table :pipelines
  end
end
