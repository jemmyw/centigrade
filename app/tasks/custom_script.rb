class CustomScript < CentigradeTask::Base
  attribute :script, :required => true
  attribute :path, :default => 'work'
  
  def execute!
    cmd_path = File.join(@path, self.path)
    cmd_file = File.join(@path, 'custom_script')

    File.open(cmd_file, 'w') do |file|
      file.write self.script
    end

    CommandLine.execute('chmod u+x %s' % cmd_file)
    cmd = '%s' % cmd_file

    begin
      CommandLine.execute(cmd, :dir => cmd_path)
      status TaskStatus::SUCCESS
    rescue CommandLine::ExecutionError => e
      status TaskStatus::FAILED
    end
  end
end