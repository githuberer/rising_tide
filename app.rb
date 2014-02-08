#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'rising_tide'


helpers do 
  include Helpers
end

rtide = Helpers::RisingTide.new

use Rack::Auth::Basic, "RisingTide-Manager" do |username, password|
  username == 'admin' and password == 'admin'
end


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
  hostname = params['hostname'].keys
  params[:result] = rtide.redis_flush(*hostname)
  erb :redis_flush_post
end


# /subfile ######
get '/subfile' do
  erb :subfile_get
end
post '/subfile' do
  params[:result] = rtide.subfile(
    params['path'].strip,                   # path(remote server)
    params['myfile'][:tempfile],            # content
    *params['hostname'].keys                # hostname
  )
  #params[:result].inspect
  erb :subfile_post
end


# /deploy #######
get '/deploy' do
  erb :deploy_get
end




