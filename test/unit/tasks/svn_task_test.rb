require 'test_helper'

class SvnTaskTest < ActiveSupport::TestCase
  context 'svn task instance' do
    setup do
      @svn = SvnTask.new('/tmp', :url => 'svn://example.com')
    end

    should 'call checkout if no version is checked out' do
      File.expects(:exists?).with('/tmp/work').returns(false)
      Subversion.any_instance.expects(:up_to_date?).returns(false)
      Subversion.any_instance.expects(:checkout)
      @svn.stubs(:update_log_data)
      @svn.execute

      assert_equal TaskStatus::SUCCESS, @svn.status
    end

    should 'call update if a new version is detected' do
      File.expects(:exists?).with('/tmp/work').returns(true)
      Subversion.any_instance.expects(:up_to_date?).returns(false)
      Subversion.any_instance.expects(:update)
      @svn.stubs(:update_log_data)
      @svn.execute

      assert_equal TaskStatus::SUCCESS, @svn.status
    end

    should 'return wait if there is no new version' do
      Subversion.any_instance.expects(:up_to_date?).returns(true)
      @svn.stubs(:update_log_data)
      @svn.execute
      
      assert_equal TaskStatus::WAIT, @svn.status
    end

    should 'update the log data with the whole log if there is no data' do
      Subversion.any_instance.stubs(:up_to_date?).returns(true)
      Subversion.any_instance.expects(:log).with('0', 'HEAD').returns("data")
      Subversion::LogParser.any_instance.expects(:parse).with("data").returns("other data")
      @svn.stubs(:data).returns({})
      @svn.execute

      assert_equal "other data", @svn.data[:log]
    end

    should 'update the log data with new log if there is already data' do
      revision = mock(:number => 2)
      Subversion.any_instance.stubs(:up_to_date?).returns(true)
      Subversion.any_instance.expects(:log).with('3', 'HEAD').returns("data")
      Subversion::LogParser.any_instance.expects(:parse).with("data").returns(["other data"])
      @svn.stubs(:data).returns({:log => [revision]})
      @svn.execute

      assert_equal [revision, "other data"], @svn.data[:log]
    end
  end
end
