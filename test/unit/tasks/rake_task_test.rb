require 'test_helper'

class RakeTaskTest < ActiveSupport::TestCase
  context 'simple rake task' do
    setup do
      @rake = RakeTask.new('/tmp', :task => 'test')
    end

    should 'run rake in the work directory' do
      CommandLine.expects(:execute).with('rake test', :dir => '/tmp/work')
      @rake.execute
    end

    should 'set status to success if the rake task returns 0' do
      CommandLine.expects(:execute).with('rake test', :dir => '/tmp/work')
      @rake.execute
      assert_equal TaskStatus::SUCCESS, @rake.status
    end

#    should 'set status to failure if the rake task returns other than 0' do
#      CommandLine.expects(:execute).with('rake test', :dir => '/tmp/work').raises(CommandLine::ExecutionError)
#      @rake.execute
#
#      assert_equal TaskStatus::FAILED, @rake.status
#    end
  end
end