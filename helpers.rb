#!/usr/bin/env ruby

Dir["models/*.rb"].each { |e| require_relative e }
#require_relative 'models/main'
#require_relative 'models/deploy'
#require_relative 'models/sync_original_music'
#require_relative 'models/check_server_health'

module Helpers
  include Main
  include Deploy
  include SyncMcOm
  include CheckServerHealth
  include V5music
end


