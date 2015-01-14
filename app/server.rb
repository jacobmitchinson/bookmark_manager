require 'sinatra/base'

require './lib/user'

require './lib/tag'

require './lib/database_setup'

require_relative './helpers/application_helper'

class BookmarkManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'super_secret'

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
    erb :"users/new"
  end

  post '/users' do 
    user = User.create(:email => params[:email],
                       :password => params[:password])
    session[:user_id] = user.id 
    redirect to('/')
  end

  get '/tags/:text' do
    tag = Tag.first(:text => params[:text])
    @links = tag ? tag.links : []
    erb :index
  end
  
  # start the server if ruby file executed directly
  run! if app_file == $0
end
