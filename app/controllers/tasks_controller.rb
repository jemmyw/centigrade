class TasksController < ApplicationController
  before_filter :load_task_types, :only => [:new, :create, :edit, :update]
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

  def update
    self.resource = find_resource
    self.resource.attributes = params[resource_name]
    self.resource.options = options_from_attributes if params[:attributes]

    respond_to do |format|
      if resource.save
        format.html do
          flash[:notice] = "#{resource_name.humanize} was successfully updated."
          redirect_to resource_url
        end
        format.js
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js   { render :action => "edit" }
        format.xml  { render :xml => resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  alias :old_new_resource :new_resource
  def new_resource(attributes = (params[resource_name] || {}))
    task = old_new_resource(attributes)
    task.options = options_from_attributes if params[:attributes]
    task
  end

  private

  def options_from_attributes
    params[:attributes].collect{|k,v| TaskOption.new(:name => k, :value => v)}
  end

  def load_task_types
    @task_types = Dir.glob('app/tasks/*.rb').sort.collect do |task_file|
      Kernel.const_get(File.basename(task_file, File.extname(task_file)).classify) rescue nil
    end.compact
  end
end
