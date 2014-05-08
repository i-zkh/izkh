server '54.214.48.185', :web, :app, :db, primary: true

set :user, 'ubuntu'

set :branch, 'master'
set :rails_env, 'production'
