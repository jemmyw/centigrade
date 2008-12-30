require 'test_helper'

class TaskOptionTest < ActiveSupport::TestCase
  should_belong_to :task
  should_require_attributes :name
end
