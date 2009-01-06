Factory.sequence :project_name do |n|
  "Test Project #{n}"
end

Factory.define :project do |p|
  p.name {|p| Factory.next(:project_name) }
#  p.pipelines do |pipelines|
#    [pipelines.association(:pipeline)]
#  end
end