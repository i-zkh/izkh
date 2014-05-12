server '54.245.202.30', :web, :app, :db, primary: true

set :user, 'ubuntu'

set :branch, 'master'
set :rails_env, 'staging'
