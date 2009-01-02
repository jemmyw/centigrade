require 'test_helper'

class WaitForTaskTest < ActiveSupport::TestCase
  context 'task has never run' do
    setup do
      @task = Factory(:task, :finished_at => nil)
    end

    should 'return wait' do
      wof = WaitForTask.new('/tmp', :task_id => @task.id)
      wof.execute

      assert_equal TaskStatus::WAIT, wof.status
    end
  end

  context 'task ran in the past' do
    setup do
      @task = Factory(:task, :finished_at => Time.now - 100)
    end

    should 'return wait' do
      wof = WaitForTask.new('/tmp', :task_id => @task.id)
      wof.stubs(:data).returns({:finished_at => Time.now})
      wof.execute

      assert_equal TaskStatus::WAIT, wof.status
    end
  end

  context 'task ran in the future' do
    setup do
      @task = Factory(:task, :finished_at => Time.now + 100)
    end

    should 'return success' do
      wof = WaitForTask.new('/tmp', :task_id => @task.id)
      wof.stubs(:data).returns({:finished_at => @task.finished_at - 100})
      wof.execute

      assert_equal TaskStatus::SUCCESS, wof.status
    end
  end
end
