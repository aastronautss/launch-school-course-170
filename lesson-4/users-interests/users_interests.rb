require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'

before do
  @users = YAML.load_file('data/users.yml')
end

not_found do
  redirect ''
end

helpers do
  def stringify(symbol)
    symbol.to_s.capitalize
  end

  def count_interests
    @users.inject(0) do |sum, (_, info)|
      sum + info[:interests].size
    end
  end

  def count_users
    @users.keys.length
  end
end

get '/' do
  erb :home
end

get '/users/:name' do
  @user_name = params[:name].capitalize
  @user = @users[params[:name].to_sym]
  @user_email = @user[:email]
  @user_interests = @user[:interests]

  erb :user
end
