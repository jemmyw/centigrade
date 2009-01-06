class TasksController < ApplicationController
  before_filter :load_task_types, :only => [:new, :create, :edit]
  layout 'default'

  resources_controller_for :tasks

  def new
    self.resource = new_resource
    self.resource.task_type ||= @task_types.first.name

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.xml  { render :xml => resource }
    end
  end

  def create
    self.resource = new_resource

    respond_to do |format|
      if resource.save
        format.html do
          flash[:notice] = "#{resource_name.humanize} was successfully created."
          redirect_to resource_url
        end
        format.js
        format.xml  { render :xml => resource, :status => :created, :location => resource_url }
      else
        format.html { render :action => "new" }
        format.js   { render :action => "new" }
        format.xml  { render :xml => resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  def load_task_types
    @task_types = Dir.glob('app/tasks/*.rb').sort.collect do |task_file|
      Kernel.const_get(File.basename(task_file, File.extname(task_file)).classify) rescue nil
    end.compact
  end
end
