# config valid only for current version of Capistrano
lock '3.3.4'

set :application, 'mutation-instability-filter'
set :repo_url, 'git@github.com:arrayjam/mutation-instability-filter.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do |host|
      within release_path do
        sudo :bundle, "exec foreman export upstart /etc/init -a #{fetch(:application)} -u #{host.user} -l #{shared_path.join('log')}"

      end
    end
  end

  desc "Start the application services"
  task :start do
    sudo "start #{fetch(:application)}"
  end

  desc "Stop the application services"
  task :stop do
    sudo "stop #{fetch(:application)}"
  end

  desc "Restart the application services"
  task :restart do
    run "sudo start #{fetch(:application)} || sudo restart #{fetch(:application)}"
  end

  after "deploy:updated", "foreman:export"
  after "deploy:updated", "foreman:restart"
end

