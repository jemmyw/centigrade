require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  should_require_attributes :name
  should_have_many :pipelines

  context 'a project instance' do
    setup do
      @project = Factory(:project)
      @project.pipelines << Factory(:pipeline, :project => @project)
      @project.pipelines(true)
    end

    should 'execute pipelines when executed' do
      @project.pipelines.each{|p| p.expects(:execute)}
      @project.execute
    end
  end
end
