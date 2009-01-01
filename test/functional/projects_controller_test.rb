require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  context 'on GET to :show' do
    setup { get :show, :id => 1 }

    should_assign_to :project
    should_respond_with :success
    should_render_template :show
  end
end
