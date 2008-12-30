require 'ostruct'

class Task < ActiveRecord::Base
  belongs_to :pipeline
  has_many :options, :class_name => "TaskOption"
  validates_presence_of :name

  def run

  end

  def status

  end

  def messages

  end
end
