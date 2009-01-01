require File.dirname(__FILE__) + '/../test_helper'

class TestTask < Centigrade::Task::Base
  attribute :test_attribute
  attribute :test_required_attribute, :required => true

  def execute!
    "hello"
  end
end

class CentigradeTaskTest < ActiveSupport::TestCase
  context 'a task instance' do
    setup do
      @task = TestTask.new(
        :test_attribute => 'test',
        :test_required_attribute => 'required test'
      )
    end

    should 'have attributes as accessors' do
      assert_equal 'test', @task.test_attribute
      assert_equal 'required test', @task.test_required_attribute
    end

    should 'set project and path then call execute! when execute is called' do
      project = Factory(:project)
      task = Factory(:task)

      @task.expects(:execute!).returns('hello')
      assert_equal 'hello', @task.execute(project, task)
      assert_equal project, @task.instance_variable_get('@project')
      assert_equal task, @task.instance_variable_get('@task')
    end
  end

  should 'error if created without required attribute' do
    assert_raise Centigrade::Task::Attributes::AttributeError do
      TestTask.new(:test_attribute => 'test')
    end
  end
end
