require 'test_helper'

class GitTaskTest < ActiveSupport::TestCase
  context 'git task instance' do
    setup do
      @git = GitTask.new('/tmp/test', :url => 'git://example.com')
      @centigrade_git = mock()
      @centigrade_git.stubs(:up_to_date?).returns(true)
      @centigrade_git.stubs(:log).returns([])
      Centigrade::Git.stubs(:new).returns(@centigrade_git)
    end

    should 'create a new git instance' do
      Centigrade::Git.expects(:new).with({:path => '/tmp/test/work', :url => 'git://example.com'}).returns(@centigrade_git)
      @git.execute
    end

    should 'check if the repo is up to date and return wait if it is' do
      @centigrade_git.expects(:up_to_date?).returns(true)
      @git.execute
      assert_equal TaskStatus::WAIT, @git.status
    end

    should 'check if the repo is out of date and check it out then return success' do
      @centigrade_git.expects(:up_to_date?).returns(false)
      @centigrade_git.expects(:clone_or_pull)
      @git.execute
      assert_equal TaskStatus::SUCCESS, @git.status
    end
  end
end
