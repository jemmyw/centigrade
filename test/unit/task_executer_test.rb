require 'test_helper'
require 'test/fixtures/test_task'

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
    
    should 'pass messages back from the task' do
      messages = ['message one', 'message two']
      
      TestTask.any_instance.stubs(:execute)
      TestTask.any_instance.stubs(:messages).returns(messages)
      
      @executer.execute
      assert_equal messages, @executer.messages
    end

    should 'pass status back from the task' do
      status = TaskStatus::SUCCESS

      TestTask.any_instance.stubs(:execute)
      TestTask.any_instance.stubs(:status).returns(status)

      @executer.execute
      assert_equal status, @executer.status
    end

    should 'create a task_run during execute' do
      TestTask.any_instance.stubs(:execute)
      TestTask.any_instance.stubs(:status).returns('create task_run')
      TestTask.any_instance.stubs(:messages).returns(%W{create task_run})

      assert_difference("TaskRun.count") do
        @executer.execute
        @task_run = @task.last_run

        assert_equal 'create task_run', @task_run.status
        assert_equal 2, @task_run.messages.size
        assert_equal 'create', @task_run.messages.first.message
        assert_equal 'task_run', @task_run.messages.last.message
      end
    end

  end
end
