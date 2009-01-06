class CreateFile < CentigradeTask::Base
  attribute :filename, :required => true
  attribute :path, :default => 'work'
  attribute :contents, :required => true

  def execute!
    File.open(File.join(@path, self.path, self.filename), 'w') do |file|
      file.write self.contents
    end
    
    status TaskStatus::SUCCESS
  end
end