#!/usr/bin/env ruby
Dir["models/*.rb"].each { |e| require_relative e }

module Models
  include Main
  include Rearrange
  Deploy = ::Deploy
  SyncMcOm = ::SyncMcOm
  CheckServerHealth = ::CheckServerHealth
  V5music = ::V5music
end
