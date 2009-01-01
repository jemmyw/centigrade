class TestTask < CentigradeTask::Base
  attribute :test_attribute
  attribute :test_required_attribute, :required => true
  attribute :test_default_attribute, :default => 'mongoose'

  def execute!
    "hello"

    status = "hello"
    message = "goodbye"
  end
end