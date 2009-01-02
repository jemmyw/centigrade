require 'command_line'

class RakeTask < CentigradeTask::Base
  attribute :task, :required => true
  attribute :path, :default => 'work'
  attribute :options, :default => ''

  def execute!
    cmd_path = File.join(@path, self.path)
    cmd = ('rake %s' % self.options).strip + ' %s' % self.task

    begin
      CommandLine.execute(cmd, :dir => cmd_path)
      status TaskStatus::SUCCESS
    rescue CommandLine::ExecutionError => e
      status TaskStatus::FAILED
    end
  end
end