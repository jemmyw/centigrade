require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  should_require_attributes :name
  should_have_many :pipelines
end
