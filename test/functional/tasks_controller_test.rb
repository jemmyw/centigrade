require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  should 'route index' do
    options = {
      :controller => 'tasks',
      :action => 'index',
      :project_id => "1",
      :pipeline_id => "1"
    }

    assert_routing('/projects/1/pipelines/1/tasks', options)
  end

  should 'route show' do
    options = {
      :controller => 'tasks',
      :action => 'show',
      :project_id => "1",
      :pipeline_id => "1",
      :id => "1"
    }

    assert_routing('/projects/1/pipelines/1/tasks/1', options)
  end

  context "create a new task" do
    setup do
      @pipeline = Factory(:pipeline)
      @project = @pipeline.project
    end

    should 'get new' do
      get :new, :project_id => @project.id, :pipeline_id => @pipeline.id
      assert_response :success
      assert assigns(:task)
      assert assigns(:task_types)
      assert_template 'new'
    end

    should 'post new.js' do
      get :new, :project_id => @project.id, :pipeline_id => @pipeline.id, :format => 'js'
      assert_response :success
      assert_template 'new.rjs'
    end

    should 'post create with valid attributes should create task' do
      assert_difference "Task.count", 1 do
        post(:create, {:project_id => @project.id, :pipeline_id => @pipeline.id,
            :task => {:task_type => 'TestTask', :name => 'test task 1'},
            :attributes => {:test_required_attribute => 'test'}})
      end

      assert_redirected_to :action => "show", 
        :project_id => @project.id.to_s,
        :pipeline_id => @pipeline.id.to_s,
        :id => Task.all.last.id.to_s
    end

    should 'post create with invalid attributes should not create task and render new' do
      assert_no_difference "Task.count" do
        post :create,:project_id => @project.id, :pipeline_id => @pipeline.id,
          :task => {:task_type => 'TestTask'}
      end

      assert_response :success
      assert_template 'new'
    end
  end
end
