Factory.define :project do |p|
  p.name 'test_project'
  p.pipelines do |pipelines|
    [pipelines.association(:pipeline)]
  end
end