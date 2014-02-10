#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'rising_tide'

# Ensure the application’s root directory
#set :root, File.dirname(__FILE__)


# Password Auth
use Rack::Auth::Basic, "RisingTide-Manager" do |username, password|
  username == 'admin' and password == 'admin'
end


# customs
helpers do 
  include Helpers
end

rtide = Helpers::RisingTide.new



# routes #################

# /
get '/' do
  erb :index
end

# /redis ########
get '/redis' do
  redirect '/redis/flush'
end
get '/redis/flush' do
  erb :redis_flush_get
end
post '/redis/flush' do
  #params.inspect
  hostname = params['hostname']
  params[:result] = rtide.redis_flush(*hostname)
  erb :redis_flush_post
end


# /subfile ######
get '/subfile' do
  erb :subfile_get
end
post '/subfile' do
  Dir.pwd
  #params[:result] = rtide.subfile(
  #  params['path'].strip,                   # path(remote server)
  #  params['myfile'][:tempfile],            # content
  #  *params['hostname']                     # hostname
  #)
  #params[:result].inspect
  #erb :subfile_post
end


# /deploy #######
get '/deploy' do
  erb :deploy_get
end
post '/deploy' do
  params.inspect
end



