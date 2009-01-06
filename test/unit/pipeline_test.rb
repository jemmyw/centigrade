require File.dirname(__FILE__) + '/../test_helper'

class PipelineTest < ActiveSupport::TestCase
  should_belong_to :project
  should_have_many :tasks

  context 'a pipeline instance' do
    setup do
      @project = Factory(:project)
      @pipeline = Factory(:pipeline, :project => @project)

      3.times do
        @pipeline.tasks << Factory(:task, :pipeline => @pipeline)
      end

      # reload the tasks after creating them
      @pipeline.tasks(true)
    end

    should 'should execute first task and stop if it fails' do
      first_task = @pipeline.tasks.first

      failing_executer = TaskExecuter.new(first_task)
      failing_executer.stubs(:status).returns(TaskStatus::FAILED)
      first_task.expects(:execute).once.returns(failing_executer)

      @pipeline.tasks[1..-1].each{|t| t.expects(:execute).never}
      @pipeline.execute
    end

    should 'should execute second task if first task succeeds' do
      first_task = @pipeline.tasks.first
      second_task = @pipeline.tasks[1]

      # Setup the first task
      succeeding_executor = TaskExecuter.new(first_task)
      succeeding_executor.stubs(:status).returns(TaskStatus::SUCCESS)
      first_task.expects(:execute).once.returns(succeeding_executor)

      # Setup the second task
      failing_executer = TaskExecuter.new(second_task)
      failing_executer.stubs(:status).returns(TaskStatus::FAILED)
      second_task = second_task
      second_task.expects(:execute).once.returns(failing_executer)

      @pipeline.execute
    end

  end
end
