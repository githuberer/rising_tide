#!/usr/bin/env ruby
require 'sinatra/base'
require_relative 'models'
#require 'sinatra/reloader' if development?


class App < Sinatra::Base
  include Models
  #set :bind, '0.0.0.0'
  #set :port, $app_port
  set environment, :development #:production
  set :server, :puma
  enable :lock
  enable :sessions
  set :sessions, 5


  use Rack::Auth::Basic, 'RisingTide-Manager' do |username, password|
    username == $rtm_user and password == $rtm_password
  end


  get '/' do
    redirect '/note'
  end
  get '/note' do
    haml :note
  end
  get '/about' do
    haml :about
  end


  get '/redis' do
    haml :redis_flush_get
  end
  post '/redis' do
    params.inspect
    unless params.include?('hostname')
      session['error'] = "Please select at least one hostname."
      redirect '/redis' 
    end
    params['result'] = Main.redis_flush(params['hostname'])
    haml :redis_flush_post
  end

  get '/subfile' do
    haml :subfile_get
  end
  post '/subfile' do
    params['path'].strip!                   # path(remote server)
    unless params.include?('myfile')
      session['error1'] = "Please select and upload file."
      redirect '/subfile' 
    end
    unless params['path'].size > 0
      session['error2'] = "Please type in file path."
      redirect '/subfile' 
    end
    unless params.include?("hostname")
      session['error3'] = "Please select at least one hostname."
      redirect '/subfile' 
    end

    params['result'] = Main.subfile(
      params['path'],                         # path(remote server)
      params['myfile'][:tempfile],            # content
      params['hostname']                      # hostname
    )
    haml :subfile_post
  end


  get '/deploy' do
    haml :deploy_get
  end
  post '/deploy' do
    unless params.include?('myfile')
      session['error'] = "Please select and upload file."
      redirect 'deploy'
    end

    content = params['myfile'][:tempfile]
    packname = params['myfile'][:filename]
    action = params['commit']

    unless $packnames.include?(packname)
      session['error'] = "\"#{packname}\" not support to deploy. \n Valid packname: #{$packnames.join(', ')}"
      redirect 'deploy'
    end

    mdeploy = Models::Deploy.new(packname, content, action)
    params['result'] = mdeploy.deploy
    haml :deploy_post
  end


  get '/deploy/confile' do
    confile_uri = "upload/v5backup-config.properties/#{params['packname'].sub(/\.\w+$/, '')}"
    params['content'] = File.read(confile_uri)
    case params['commit']
    when "view"
      haml :deploy_confile_view, :layout => false
    when "modify"
      haml :deploy_confile_modify, :layout => false
    else
      redirect '/deploy'
    end
  end
  post '/deploy/confile/modify/:packname' do
    confile_uri = "upload/v5backup-config.properties/#{params['packname'].sub(/\.\w+$/, '')}"
    File.open(confile_uri, 'w') { |f| f.write(params['content']) }
    redirect "/deploy/confile?packname=#{params['packname']}&commit=view"
  end


  get '/sync_mc_om' do
    haml :sync_mc_om_get
  end
  post '/sync_mc_om' do
    params['ids'] = params['ids'].split("\s").select { |e| e =~ /(^\d+$|^\d+\.\.\d+$)/ }  # params['ids'] is an Array
    params['ids'].map! { |e| e.to_rge }
    params['ids'].etd_rge!

    if params['ids'].empty?
      session['error'] = "Type in at least one \"id\", or \"id\" format invalid."
      redirect 'sync_mc_om'
    end

      msync_mc_om = Models::SyncMcOm.new(params['ids'])
      params['result'] = []
      params['result'] << msync_mc_om.sync_records
      params['result'] << msync_mc_om.sync_files
      haml :sync_mc_om_post
  end


  get '/v5music' do
    haml :v5music_get
  end
  post '/v5music' do
    type = params['type']

    ids = params['ids'].split("\s").select { |e| e =~ /^\d{8}$/ }  # ids is an Array
    if ids.empty?
      session['error'] = "Type in at least one \"id\", or \"id\" format invalid."
      redirect 'v5music'
    end

    mv5music = Models::V5music.new(type, ids)
    if params.include?('myfile') and params['myfile'] =~ /.*\.zip/
      content = params['myfile'][:tempfile]
      #filename = params['myfile'][:filename]
      filename = "v5music.zip"
      mv5music.update_localfile(filename, content)
    else
      session['error'] = "Upload file format must be \"zip\"."
      redirect 'v5music'
    end
    params['result'] = mv5music.deploy
    haml :v5music_post
  end

  get '/backtrace' do
    dirs = Dir.glob("download/????-??-??").sort { |x, y| y <=> x }
    params['fileuris'] = {}
    dirs.each do |e|
      params['fileuris'].store(e.sub(/download\//, ""), Dir.glob("#{e}/**"))
    end
    haml :backtrace
  end
  get "/backtrace/rearrange" do
    Rearrange.upload_to_download
    redirect '/backtrace'
  end
  get '/backtrace/*' do |fileuri|
    send_file "#{fileuri}"
  end


  get '/debug' do
    haml :notyet
  end
  get '/monitor' do
    haml :notyet
  end
  get '/test' do
    "aaa"
  end

end
