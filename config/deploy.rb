#......................default deploy.rb file...........................................
# config valid for current version and patch releases of Capistrano
#lock "~> 3.11.0"

#set :application, "mealman"
#set :repo_url, "git@github.com:nehasan/mealman.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
# .......................default deploy.rb file end ...............................




#
# bundle exec cap staging deploy:setup_config
# bundle exec cap staging deploy
#

lock "~> 3.11.0"

set :application, "mealman"
set :repo_url, "git@github.com:nehasan/mealman.git" # Put Git url (Ex: https://github.com/user/repo.git)
set :deploy_user, :deployer
set :deploy_path, "/apps"
set :pty, true
set :tmp_dir, "/tmp"

set :rbenv_type, :system
set :rbenv_ruby, '2.5.0'
set :rbenv_prefix,
    "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)

set :keep_releases, 5

set :bundle_binstubs, nil

set :linked_files, %w(config/application.yml config/database.yml config/secrets.yml)

set(
    :linked_dirs,
    %w(log tmp/pids tmp/states tmp/sockets tmp/cache vendor/bundle public/system)
)

set(
    :config_files,
    %w(
    nginx.conf
    application.yml.template
    database.yml.template
    secrets.yml.template
    log_rotation
    puma.rb
    puma_init.sh
  )
)

set(:executable_config_files, %w(puma_init.sh))

set(
    :symlinks,
    [
        {
            source: 'nginx.conf',
            link: '/etc/nginx/sites-enabled/{{full_app_name}}.conf'
        },
        {
            source: 'puma_init.sh',
            link: '/etc/init.d/puma_{{full_app_name}}'
        },
        {
            source: 'log_rotation',
            link: '/etc/logrotate.d/{{full_app_name}}'
        }
    ]
)

namespace :deploy do
  before :deploy, 'deploy:check_revision'
  before :deploy, "deploy:run_tests"
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'
  before 'deploy:setup_config', 'nginx:remove_default_vhost'
  after 'deploy:setup_config', 'nginx:reload'
  after 'deploy:setup_config', 'monit:restart'
  after 'deploy:publishing', 'deploy:push_deploy_tag'
  after 'deploy:publishing', 'puma:restart'
end
