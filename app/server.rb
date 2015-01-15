require 'sinatra/base'
require './lib/user'
require './lib/tag'
require './app/database_setup'
require 'rack-flash'
require 'sinatra/partial'

require_relative './helpers/application_helper'

class BookmarkManager < Sinatra::Base
  use Rack::MethodOverride
  use Rack::Flash
  enable :sessions
  set :session_secret, 'super_secret'
  register Sinatra::Partial
  set :partial_template_engine, :erb

  # set :views, File.expand_path('../../views', __FILE__)
  set :views, Proc.new { File.join(root, "views") }
  
  helpers ApplicationHelper

  get '/' do
    @links = Link.all
    erb :index
  end

  post '/links' do
    url = params["url"]
    title = params["title"]
    tags = params["tags"].split(" ").map do |tag|
      # this will either find this tag or create
      # it if it doesn't exist already
      Tag.first_or_create(:text => tag)
    end
    Link.create(:url => url, :title => title, :tags => tags)
    redirect to('/')
  end

  get '/users/new' do 
    @user = User.new
    erb :"users/new"
  end

  post '/users' do 
    @user = User.create(:email => params[:email],
                       :password => params[:password],
                       :password_confirmation => params[:password_confirmation])
    
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :"users/new"
    end
  end

  get '/sessions/new' do 
    erb :"sessions/new"
  end

  post '/sessions' do 
    email, password = params[:email], params[:password]
    user = User.authenticate(email, password)
    if user
      session[:user_id] = user.id
      redirect to('/')
    else
      flash[:errors] = ["The email or password is incorrect"]
      erb :"sessions/new"
    end
  end

  get '/tags/:text' do
    tag = Tag.first(:text => params[:text])
    @links = tag ? tag.links : []
    erb :index
  end

  delete '/sessions' do
    flash[:notice] ="Good bye!"
    session[:user_id] = nil
    redirect to('/')
  end
  
  # start the server if ruby file executed directly
  run! if app_file == $0
end
