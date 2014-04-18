#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'helpers'


use Rack::Auth::Basic, 'RisingTide-Manager' do |username, password|
  username == 'admin' and password == 'admin'
end


##### Config #####################
set :port, '4567'
set :bind, '127.0.0.1'
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
    params['hostname']                     # hostname
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
  ids = params['id'].split("\s").select { |e| e =~ /^\d+$/ }  # ids is an array
  msync_mc_om = Helpers::SyncMcOm.new(ids)
  msync_mc_om.sync_records
  msync_mc_om.sync_files
  erb :sync_mc_om_post
  #params.inspect
end



