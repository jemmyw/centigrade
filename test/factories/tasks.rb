Factory.define :task do |t|
  t.name "Source checkout"
  t.task_type 'Svn'
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