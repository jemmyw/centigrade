module TaskTypesHelper
  def task_widget(task)
    @task_type = task.task_type_class
    @attributes = @task_type.attributes

    begin
      render :file => 'task_types/%s_widget.html' % @task_type.name.underscore
    rescue ActionView::MissingTemplate
      render :text => 'No widget?'
    end
  end
end
