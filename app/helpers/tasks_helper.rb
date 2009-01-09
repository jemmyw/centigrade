module TasksHelper
  def task_type_form(task_type)
    begin
      @task_type = @task.task_type_class
      @attributes = @task_type.attributes

      render :file => 'task_types/%s_form.html' % task_type.underscore
    rescue ActionView::MissingTemplate
      render :partial => 'task_attribute_form'
    end
  end

  def attribute_field_name(attribute)
    'attributes[%s]' % attribute[:name]
  end

  def attribute_field(attribute)
    attribute_text_field(attribute)
  end

  def pipeline_task_options_for_select(selected = nil)
    groups = []

    if @project.tasks.count == 0
      return '<option>(No tasks available)</option>'
    end

    @project.pipelines.each_with_index do |pipeline, index|
      groups << '<optgroup label="%s">' % "Pipeline #{index+1}" +
        pipeline.tasks.collect do |task|
        '<option value="%d">%s</option>' % [task.id, task.name]
      end.join("\n")
    end

    groups.join("\n")
  end

  def attribute_text_field(attribute)
    text_field_tag 'attributes[%s]' % attribute[:name], @task.options.find(:first, :conditions => {:name => attribute[:name].to_s}).andand.value
  end
end
