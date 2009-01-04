class TaskTypesController < ApplicationController
  def method
    @task_type = Kernel.const_get(params[:class])
    raise "invalid class" unless @task_type.superclass == CentigradeTask::Base
    render :text => @task_type.send(params[:method], params[:attributes])
  end
end
