lock "3.4.0"

set :application, "dustproof"
set :repo_url, "git@github.com:Dustproof/dustproof-webapp.git"
set :branch, "master"
set :deploy_to, "/home/rails/dustproof"
set :default_env, rvm_bin_path: "~/.rvm/bin"
set :linked_files, %w(config/database.yml config/secrets.yml config/shoryuken.yml)
set :linked_dirs, %w(tmp/pids)
set :log_level, :info

# Shoryuken
set :shoryuken_default_hooks,  true

set :shoryuken_pid,            -> { File.join(shared_path, 'tmp', 'pids', 'shoryuken.pid') }
set :shoryuken_env,            -> { fetch(:rack_env, fetch(:rails_env, fetch(:stage))) }
set :shoryuken_log,            -> { File.join(shared_path, 'log', 'shoryuken.log') }
set :shoryuken_config,         -> { File.join(release_path, 'config', 'shoryuken.yml') }
set :shoryuken_options,        -> { ['--rails'] }
set :shoryuken_queues,         -> { ['dustproof-queue-production'] }

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, "/var/www/my_app"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :publishing, :restart
end
