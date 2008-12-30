require 'test_helper'

class PipelineTest < ActiveSupport::TestCase
  should_belong_to :project
  should_have_many :tasks
end
