require 'sinatra/base'

require './lib/database_setup'

class BookmarkManager < Sinatra::Base

  # set :views, File.expand_path('../../views', __FILE__)
  set :views, Proc.new { File.join(root, "views") }

  get '/' do
    @links = Link.all
    erb :index
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
