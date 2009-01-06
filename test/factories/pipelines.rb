Factory.define :pipeline do |p|
#  p.tasks do |tasks|
#    [
#      tasks.association(:task),
#      tasks.association(:task)
#    ]
#  end
  p.association :project
end
