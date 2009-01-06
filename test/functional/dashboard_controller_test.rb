require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  context "on GET to :index" do
    setup do
      get :index
    end

    should_assign_to :projects
    should_respond_with :success
    should_render_template :index
  end
end
