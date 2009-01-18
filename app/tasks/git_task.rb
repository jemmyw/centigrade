require 'centigrade_git'

class GitTask < CentigradeTask::Base
  attribute :url, :required => true
  attribute :remote_branch
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

    @git = Centigrade::Git.new(@options.dup)

    if @git.up_to_date?
      status TaskStatus::WAIT
    else
      @git.clone_or_pull
      status TaskStatus::SUCCESS
    end

    update_log
  end

  private

  def update_log
    data[:log] = @git.log
  end
end