require 'test_helper'

class TaskMessageTest < ActiveSupport::TestCase
  should_belong_to :task_run
  should_require_attributes :message
end
