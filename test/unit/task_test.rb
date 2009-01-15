require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < ActiveSupport::TestCase
  should_require_attributes :name, :pipeline, :task_type
  should_belong_to :pipeline
  should_have_many :options
  should_have_many :runs

  context 'a new task' do
    should 'be invalid unless the class type implements attributes' do
      @task = Factory.build(:task, :task_type => nil)
      assert_equal false, @task.save
      assert @task.errors.on(:task_type).include?("class must implement attributes method")
      
      @task = Factory.build(:task, :task_type => "String")
      assert_equal false, @task.save
      assert @task.errors.on(:task_type).include?("class must implement attributes method")
    end

    should "be invalid if the options don't implement all required task attributes" do
      @task = Factory.build(:task)
      @task.options.clear
      
      assert_equal false, @task.save
      assert @task.errors.on(:options).include?("does not include required attribute test_required_attribute")
    end
  end

  context 'test task instance' do
    setup do
      @task = Factory(:task)
      
      @task.started_at = nil; @task.finished_at = nil; @task.status = TaskStatus::WAITING
      
      TaskExecuter.any_instance.stubs(:execute).returns(true)
      TaskExecuter.any_instance.stubs(:status).returns(TaskStatus::SUCCESS)
      TaskExecuter.any_instance.stubs(:messages).returns(['Test message'])
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

    should 'return success? if it has a task run with a successful status' do
      @task.runs << Factory(:task_run, :status => TaskStatus::SUCCESS, :task => @task)
      assert @task.success?
    end

    should 'not return success? if the last task run has a failed status' do
      @task.runs << Factory(:task_run, :status => TaskStatus::SUCCESS, :task => @task, :created_at => Time.now - 1.hour)
      @task.runs << Factory(:task_run, :status => TaskStatus::FAILED, :task => @task, :created_at => Time.now)

      assert_equal false, @task.success?
    end

    should 'not return success? if there are no task runs' do
      assert_equal 0, @task.runs.size
      assert_equal false, @task.success?
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
