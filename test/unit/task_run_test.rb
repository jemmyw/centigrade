require 'test_helper'

class TaskRunTest < ActiveSupport::TestCase
  should_belong_to :task
  should_have_many :messages
end
