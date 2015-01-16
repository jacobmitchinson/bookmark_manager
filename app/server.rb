require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require 'sinatra/partial'
require_relative "models/link"
require_relative 'models/tag'
require_relative "models/user"
require_relative 'helpers/application_helper'
require_relative 'database_setup'

require_relative 'controllers/users'
require_relative 'controllers/sessions'
require_relative 'controllers/links'
require_relative 'controllers/tags'
require_relative 'controllers/application'

require_relative './helpers/application_helper'

use Rack::MethodOverride
use Rack::Flash
enable :sessions
set :session_secret, 'super_secret'
register Sinatra::Partial
set :partial_template_engine, :erb

# set :views, File.expand_path('../../views', __FILE__)
set :views, Proc.new { File.join(root, "views") }

helpers ApplicationHelper

get '/users/reset' do 
  erb :'users/reset'
end

post '/users/reset' do 
  email = params[:email]
  user = User.first(:email => email)
  user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
  user.save
  erb :'users/reset'
end

get '/users/reset/:token' do 
  user = User.first(:password_token => params[:token])
  @token = user.password_token
  erb :'users/change_password'
end

post '/sessions/password_reset' do 
  puts "hello"
  password = params[:password]
  password_confirmation = params[:password_confirmation]
  token = params[:password_token]
  user = User.first(:password_token => token)
  user.update(:password => password, :password_confirmation => password_confirmation)
  user.password_digest
  user.save
end