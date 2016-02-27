require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

get '/' do
  @files = Dir.glob('public/*').sort

  @desc = @params['sort'] == 'desc'

  @files.reverse! if @desc

  erb :index
end
