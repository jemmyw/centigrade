require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  context 'on GET to :new' do
    setup do
      get :new
    end

    should_assign_to :task_types
    should_respond_with :success
    should_render_template :new
  end
end
