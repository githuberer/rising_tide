#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'lib/helpers'


#####Config#####################

set :port, '4567'
set :bind, '127.0.0.1'
set :lock, true
set :sessions, true                         # disabled default
#set environment, :production
#set :show_exceptions, false
#set :root, File.dirname(__FILE__)          # set application’s root directory to current file's dir
#set :app_file, __FILE__

use Rack::Auth::Basic, 'RisingTide-Manager' do |username, password|
  username == 'admin' and password == 'admin'
end


helpers { include Helpers }
rtide = Helpers::RisingTide.new

#####Routes#####################

get '/test' do
  erb :subfile_post
end

get '/' do
  erb :index
end

get '/redis' do
  redirect '/redis/flush'
end
get '/redis/flush' do
  erb :redis_flush_get
end
post '/redis/flush' do
  params['result'] = rtide.redis_flush(*params['hostname'])
  erb :redis_flush_post
  #params.inspect
  #params['result'].inspect
end

get '/subfile' do
  erb :subfile_get
end
post '/subfile' do
  params['result'] = rtide.subfile(
    params['path'].strip,                   # path(remote server)
    params['myfile'][:tempfile],            # content
    *params['hostname']                     # hostname
  )
  erb :subfile_post
  #params.inspect
end

get '/deploy' do
  erb :deploy_get
end
post '/deploy' do
  #package = params['package']
  #params['result'] = rtide.deploy("v5backup", *package)
  #erb :deploy_post
  params.inspect
end

get '/sync_original_music' do
  erb :sync_original_music_get
end
post '/sync_original_music' do
  params['result'] = rtide.sync_original_music(params['id'])
  params['result'].inspect
end



