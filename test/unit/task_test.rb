require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  should_require_attributes :name
  should_belong_to :pipeline
  should_have_many :options
end
