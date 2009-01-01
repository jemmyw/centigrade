require 'centigrade_task'

path = File.join(RAILS_ROOT, 'app', 'tasks')
$LOAD_PATH << path
ActiveSupport::Dependencies.load_paths << path