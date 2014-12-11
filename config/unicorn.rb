#worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
#timeout 15
#preload_app true

#before_fork do |server, worker|
  #Signal.trap 'TERM' do
    #puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    #Process.kill 'QUIT', Process.pid
  #end

  #defined?(ActiveRecord::Base) and
    #ActiveRecord::Base.connection.disconnect!
#end

#after_fork do |server, worker|
  #Signal.trap 'TERM' do
    #puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  #end

  #defined?(ActiveRecord::Base) and
    #ActiveRecord::Base.establish_connection
#end

app_name = "mutation-instability-filter"
# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/var/www/#{app_name}/current"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/var/www/#{app_name}/current/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "/var/www/#{app_name}/current/log/unicorn.log"
stdout_path "/var/www/#{app_name}/current/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.#{app_name}.sock"
#listen "/tmp/unicorn.myapp.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
