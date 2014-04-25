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
  if params.keys.include?('myfile')
    content = params['myfile'][:tempfile]
    packname = params['myfile'][:filename]
    action = params['commit']

    if $packnames.include?(packname)
      mdeploy = Helpers::Deploy.new(packname, content, action)
      params['result'] = mdeploy.deploy
      #params.inspect 
      erb :deploy_post
    else
      redirect 'deploy'
    end

  else
    redirect 'deploy'
  end
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
    erb :sync_mc_om_post
    #params.inspect
    #msync_mc_om.test
  else
    redirect 'sync_mc_om'
  end
end


get '/v5music' do
  erb :v5music_get
end

post '/v5music' do
  type = params['type']
  ids = params['ids'].split("\s").select { |e| e =~ /^\d{8}$/ }  # ids is an Array

  unless ids.empty?
    mv5music = Helpers::V5music.new(type, ids)

    if params.keys.include?('myfile')
      content = params['myfile'][:tempfile]
      #filename = params['myfile'][:filename]
      filename = "v5music.zip"
      mv5music.update_localfile(filename, content)
    end

    params['result'] = mv5music.deploy
    erb :v5music_post
  else 
    redirect '/v5music'
  end
end

get '/debug' do
  erb :notyet
end

get '/monitor' do
  erb :notyet
end

