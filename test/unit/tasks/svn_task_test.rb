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
      @svn.execute

      assert_equal TaskStatus::SUCCESS, @svn.status
    end

    should 'call update if a new version is detected' do
      File.expects(:exists?).with('/tmp/work').returns(true)
      Subversion.any_instance.expects(:up_to_date?).returns(false)
      Subversion.any_instance.expects(:update)
      @svn.execute

      assert_equal TaskStatus::SUCCESS, @svn.status
    end

    should 'return wait if there is no new version' do
      Subversion.any_instance.expects(:up_to_date?).returns(true)
      @svn.execute
      
      assert_equal TaskStatus::WAIT, @svn.status
    end
  end
end
