module TaskTypesHelper
  def task_widget(task)
    @task_type = task.task_type_instance
    @attributes = @task_type.class.attributes

    begin
      render :file => 'task_types/%s_widget.html' % @task_type.class.name.underscore
    rescue ActionView::MissingTemplate
      render :text => 'No widget?'
    end
  end
end
