require File.dirname(__FILE__) + '/../test_helper'
require 'centigrade_git'

class CentigradeGitTest < ActiveSupport::TestCase
  context 'a git class' do
    setup do
      @options = {:path => '/tmp/test', :url => 'git://example.com'}
      @git = Centigrade::Git.new(@options)
    end

    should 'not be up to date to begin with' do
      assert_equal false, @git.up_to_date?
    end

    context 'already cloned' do
      setup do
        @git_obj = mock
        Git.expects(:open).at_least_once.with(@options[:path]).returns(@git_obj)
      end

      should 'be up to date if there are no remote commits' do
        @git_obj.expects(:fetch)
        @git_obj.expects(:checkout).with('master').returns('Already on master')
        assert_equal true, @git.up_to_date?
      end

      should 'not be up to date if there are remote commits' do
        @git_obj.expects(:fetch)
        @git_obj.expects(:checkout).with('master').returns(%Q{Already on master.
          Your branch is behind origin/master by 1 commit, and can be fast-forwarded})
        assert_equal false, @git.up_to_date?
      end

      should 'call checkout then pull on pull' do
        @git_obj.expects(:checkout).with('master')
        @git_obj.expects(:pull)
        @git.pull
      end

      should 'call pull on clone or pull' do
        @git.expects(:pull)
        @git.expects(:clone).never
        @git.clone_or_pull
      end
    end

    context 'not yet cloned' do
      setup do
        Git.expects(:open).at_least_once.with(@options[:path]).raises(ArgumentError, "Invalid path")
      end

      should 'call clone on clone or pull' do
        @git.expects(:clone)
        @git.expects(:pull).never
        @git.clone_or_pull
      end
    end

    should 'call Git.clone on clone' do
      Git.expects(:clone).with(@options[:url], @options[:path])
      @git.clone
    end
  end
end
