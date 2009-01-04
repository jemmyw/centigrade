require 'subversion'

class SvnTask < CentigradeTask::Base
  attribute :url, :required => true
  attribute :username
  attribute :password
  
  def execute!
    path = File.join(@path, 'work')
    @options = {
      :url => self.url,
      :path => path
    }

    @options[:username] = self.username unless self.username.blank?
    @options[:password] = self.password unless self.password.blank?

    @subversion = Subversion.new(@options)

    reasons = []

    message "Checking #{url}"
    if @subversion.up_to_date?(reasons)
      reasons.each {|r| message r}
      status TaskStatus::WAIT and return
    end

    if File.exists?(path)
      message "Updating from #{url}"
      @subversion.update
    else
      message "Checking out from #{url}"
      @subversion.checkout
    end
    
    status TaskStatus::SUCCESS
  end

  def self.verify(attributes)
    begin
      subversion = Subversion.new(attributes)
      subversion.info(true)
      "Verified"
    rescue Exception => e
      "Error: #{e}"
    end
  end
end