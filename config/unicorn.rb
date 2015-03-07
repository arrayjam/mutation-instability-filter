require 'dotenv'
before_fork do |server, worker|
    Dotenv.load
end

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
