class TestTask < CentigradeTask::Base
  attribute :test_attribute
  attribute :test_required_attribute, :required => true

  def execute!
    "hello"
  end
end

Factory.define :task do |t|
  t.name "Test task"
  t.task_type 'TestTask'
  t.options {|o|
    [
      o.association(:task_option, :name => 'test_attribute', :value => 'hello'),
      o.association(:task_option, :name => 'test_required_attribute', :value => 'goodbye')
    ]
  }
  t.messages {|m|
    [
      m.association(:task_message),
      m.association(:task_message)
    ]
  }
end

Factory.define :svn_task, :class => Task do |t|
  t.name "Source checkout"
  t.task_type 'SvnTask'
  t.options {|o|
    [
      o.association(:task_option, :name => 'url', :value => 'svn://example.com'),
      o.association(:task_option, :name => 'username', :value => 'test'),
      o.association(:task_option, :name => 'password', :value => 'test')
    ]
  }
  t.messages {|m|
    [
      m.association(:task_message),
      m.association(:task_message)
    ]
  }
end

Factory.define :task_option do |t|
  t.name 'test'
  t.value 'test'
end

Factory.define :task_message do |m|
  m.status 'failed'
  m.message "Test Message"
end