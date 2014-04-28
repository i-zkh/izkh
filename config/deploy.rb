#TODO: change this to application name
set :application, 'iz-revival'

#TODO: change this to repository
set :repository, 'https://jwsilent@github.com/jwsilent/iz-revival.git'

# set :deploy_subdir, ''

set :default_stage, :staging

# Uses Brightbox Next Generation Ruby Packages
# http://wiki.brightbox.co.uk/docs:ruby-ng
# by default.
# Change to specific version in ruby-build format
# if exact version needed.
#valid brightbox "1.9.3" and "2.0"
set :ruby_version, "2.0"
set :ruby_source, :brightbox
set :care_about_ruby_version, false

set :postgresql,
    version: '9.1',
    listen_all: false #TODO: changes this to `true` for TCP connectivity

set :monit,
    notify_email: 'mamonov.nick@gmail.com', #TODO: change this to your email to receive monit alerts
    poll_period: 30

set :railsapp,
    server_names: '_' #TODO: change this to domain name(s) of the project

set :aws,
    access_key_id: '',
    secret_access_key: '' #TODO: set this to let railsapp::backup put backups in s3

set :ssh_login_options, '-i ~/.ssh/aws.pem -C -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -L 3737:localhost:3737'
ssh_options[:keys] = ["~/.ssh/aws.pem"]

# Show ASCII beautiful deer in console before deploy.
# True by default
#set :show_beautiful_deer, false

# Ask confirmation [Y/N] before deploy. It should be true for production stages.
# True by default
#set :ask_confirmation, false

# For other options look into cookbooks/*/attributes/default.rb
# and other cookbook sources.

set :run_list, %w(
  recipe[monit]
  recipe[monit::ssh]
  recipe[postgresql]
  recipe[nginx]
  recipe[railsapp]
  recipe[railsapp::backup]
  recipe[ubuntu]
)
  
namespace :deploy do  
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

