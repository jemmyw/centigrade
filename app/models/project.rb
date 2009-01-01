class Project < ActiveRecord::Base
  has_many :pipelines
  validates_presence_of :name

  def path
    File.join(PROJECTS_ROOT, self.name)
  end

  def execute
    @pipelines.each do |pipeline|
      pipeline.execute
    end
  end
end
