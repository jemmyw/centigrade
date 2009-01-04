require File.dirname(__FILE__) + '/../test_helper'
require 'test/fixtures/test_task'

class CentigradeTaskTest < ActiveSupport::TestCase
  context 'a task class' do
    should 'have an array of attributes represented as hashes each having a name' do
      TestTask.attributes.each do |attribute|
        assert attribute.is_a?(Hash)
        assert attribute.has_key?(:name)
      end
    end

    should 'have an attribute named :test_attribute' do
      assert TestTask.attributes.include?({:name => :test_attribute})
    end

    should 'have an attribute named :test_required_attribute with :required => true' do
      assert TestTask.attributes.include?({:name => :test_required_attribute, :required => true})
    end

    should 'have 3 attributes' do
      assert_equal 3, TestTask.attributes.length
    end

    should 'be able to access attributes with name through []' do
      assert_equal({:name => :test_required_attribute, :required => true}, TestTask.attributes[:test_required_attribute])
    end
  end

  context 'a task instance' do
    setup do
      @task = TestTask.new(
        '/tmp',
        :test_attribute => 'test',
        :test_required_attribute => 'required test'
      )
    end

    should 'have attributes as accessors' do
      assert_equal 'test', @task.test_attribute
      assert_equal 'required test', @task.test_required_attribute
    end

    should 'have the default attribute filled in' do
      assert_equal 'mongoose', @task.test_default_attribute
    end

    should 'set project and path then call execute! when execute is called' do
      @task.expects(:execute!).returns('hello')
      assert_equal 'hello', @task.execute
      assert_equal '/tmp', @task.instance_variable_get('@path')
    end
  end

  should 'error if created without required attribute' do
    assert_raise CentigradeTask::Attributes::AttributeError do
      TestTask.new('/tmp', :test_attribute => 'test')
    end
  end
end
