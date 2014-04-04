#!/usr/bin/env ruby
require_relative 'models/main'
require_relative 'models/sync_original_music'
require_relative 'models/check_server_health'


module Helpers
  include Main
  include SyncOriginalMusic
  include CheckServerHealth
end


