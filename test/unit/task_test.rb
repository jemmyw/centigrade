require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  should_require_attributes :name, :pipeline
  should_belong_to :pipeline
  should_have_many :options
  should_have_many :messages

  context 'task with no task_type' do
    setup do
      @task = Factory(:task, :task_type => nil)
    end

    should 'return nil as the task class' do
      assert @task.task_type_class.nil?
    end
  end

  context 'test task instance' do
    setup do
      @task = Factory(:task)
      
      @task.started_at = nil; @task.finished_at = nil; @task.status = TaskStatus::WAITING
      
      TaskExecuter.any_instance.stubs(:execute).returns(true)
      TaskExecuter.any_instance.stubs(:status).returns(TaskStatus::SUCCESS)
      TaskExecuter.any_instance.stubs(:message).returns('Test message')
    end

    should 'return the task class on task_type_class' do
      assert_equal TestTask, @task.task_type_class
    end 

    should 'create a task executer on execute' do
      executer = @task.execute
      assert_equal TaskExecuter, executer.class
    end

    should 'update started_at and finished_at on execute' do
      @task.execute
      assert @task.started_at.is_a?(Time)
      assert @task.finished_at.is_a?(Time)
      assert @task.finished_at >= @task.started_at
    end

    should 'set status to running when waiting when executed' do
      status = states('status').starts_as('waiting')
      @task.expects(:status=).with(TaskStatus::RUNNING).when(status.is('waiting')).then(status.is('running'))
      @task.expects(:status=).with(TaskStatus::WAITING).when(status.is('running'))
      @task.execute
    end

    should 'always have a new message after execution' do
      message_count = @task.messages.size
      @task.execute
      assert_equal message_count+1, @task.messages.size

      message = @task.messages.last
      assert_equal TaskStatus::SUCCESS, message.status
      assert_equal "Test message", message.message
    end
  end
  
  context "svn task instance" do
    setup do
      @task = Factory(:svn_task)
    end

    should 'options_as_hash should create a hash from the options array' do
      hash = @task.options_as_hash
      assert_equal({'url' => 'svn://example.com', 'username' => 'test', 'password' => 'test'}, hash)
    end
  end
end
