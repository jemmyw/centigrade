require 'subversion'

class SvnTask < CentigradeTask::Base
  attribute :url, :required => true
  attribute :username
  attribute :password
  
  def execute!
    @path = File.join(@project.path, 'work')
    @options = {
      :url => self.url,
      :path => @path
    }

    @options[:username] = self.username unless self.username.blank?
    @options[:password] = self.password unless self.password.blank?

    @subversion = Subversion.new(@options)
    
    status TaskStatus::SUCCESS
  end
end