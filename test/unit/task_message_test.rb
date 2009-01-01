require 'test_helper'

class TaskMessageTest < ActiveSupport::TestCase
  should_belong_to :task
  should_require_attributes :message
end
