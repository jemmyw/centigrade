require 'test_helper'

class PipelineTest < ActiveSupport::TestCase
  should_belong_to :project
  should_have_many :tasks

  context 'a pipeline instance' do
    setup do
      @project = Factory(:project)
      @pipeline = @project.pipelines.first
    end

    should 'should execute first task and stop if it fails' do
      first_task = @pipeline.tasks.first
      first_task.expects(:execute).returns(TaskExecuter.new(first_task))
      @pipeline.tasks[1..-1].each{|t| t.expects(:execute).never}
      @pipeline.execute
    end
  end
end
