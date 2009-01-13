require 'test_helper'

class CreateFileTest < ActiveSupport::TestCase
  context 'simple create file task' do
    setup do
      @task = CreateFile.new('/tmp', :filename => 'hello.txt', :contents => 'Hi There!')
    end

    should 'create file in the tmp directory' do
      file_mock = mock()
      file_mock.expects(:write).with('Hi There!')
      File.expects(:open).with('/tmp/work/hello.txt', 'w').yields(file_mock)
      @task.execute!
      
      assert_equal TaskStatus::SUCCESS, @task.status
    end

    should 'create file in specified directory' do
      @task = CreateFile.new('/tmp', :filename => 'hello.txt', :contents => 'Hi There!', :path => 'test')
      file_mock = mock()
      file_mock.expects(:write).with('Hi There!')
      File.expects(:open).with('/tmp/test/hello.txt', 'w').yields(file_mock)
      @task.execute!
    end
  end
end