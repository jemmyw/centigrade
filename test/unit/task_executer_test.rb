require 'test_helper'

class TaskExecuterTest < ActiveSupport::TestCase
  context 'task executer instance' do
    setup do
      @task = Factory(:task)
      @project = @task.pipeline.project

      @task.task_type = 'TestTask'
      @task.options = [
        Factory(:task_option, :name => 'test_attribute', :value => 'hello'),
        Factory(:task_option, :name => 'test_required_attribute', :value => 'goodbye')
      ]
      
      @executer = TaskExecuter.new(@task)
    end

    should 'create the appropriate task class with attributes and execute' do
      TestTask.any_instance.expects(:initialize).with(
        @project.path,
        {'test_attribute' => 'hello', 'test_required_attribute' => 'goodbye'}
      )
      TestTask.any_instance.expects(:execute)
      @executer.execute
    end
  end
end
