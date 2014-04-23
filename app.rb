#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'helpers'


use Rack::Auth::Basic, 'RisingTide-Manager' do |username, password|
  username == $rtm_user and password == $rtm_password
end


##### Config #####################
set :port, '4567'
set :bind, '0.0.0.0'
set :lock, true
set :sessions, true                     
#set environment, :production
#set :show_exceptions, false
#set :root, File.dirname(__FILE__)          # set application’s root directory to current file's dir
#set :app_file, __FILE__


helpers { include Helpers }
main = Helpers::Main.new
##### Routes #####################

get '/' do
  erb :index
end

get '/about' do
  erb :about
end


get '/redis' do
  erb :redis_flush_get
end

post '/redis' do
  params['result'] = main.redis_flush(params['hostname'])
  erb :redis_flush_post
  #params.inspect
  #params['result'].inspect
end


get '/subfile' do
  erb :subfile_get
end

post '/subfile' do
  params['result'] = main.subfile(
    params['path'].strip,                   # path(remote server)
    params['myfile'][:tempfile],            # content
    params['hostname']                      # hostname
  )
  erb :subfile_post
  #params.inspect
end


get '/deploy' do
  erb :deploy_get
end

post '/deploy' do
  mdeploy = Helpers::Deploy.new(params['packname'])
  params['result'] = mdeploy.deploy(params['commit'])
  #params.inspect
  erb :deploy_post
end


get '/sync_mc_om' do
  erb :sync_mc_om_get
end

post '/sync_mc_om' do
  ids = params['ids'].split("\s").select { |e| e =~ /^\d+$/ }  # ids is an Array

  unless ids.empty?
    msync_mc_om = Helpers::SyncMcOm.new(ids)
    params['result'] = []
    params['result'] << msync_mc_om.sync_records
    params['result'] << msync_mc_om.sync_files
  else
    redirect 'sync_mc_om'
  end

  erb :sync_mc_om_post
  #params.inspect
  #msync_mc_om.test
end


get '/v5music' do
  erb :v5music_get
end

post '/v5music' do
  type = params['type']
  ids = params['ids'].split("\s").select { |e| e =~ /^\d{8}$/ }  # ids is an Array

  unless ids.empty?
    mv5music = Helpers::V5music.new(type, ids)
    params['result'] = mv5music.deploy
  else 
    redirect '/v5music'
  end

  #params.inspect
  erb :v5music_post
end

get '/debug' do
  erb :notyet
end

get '/monitor' do
  erb :notyet
end

