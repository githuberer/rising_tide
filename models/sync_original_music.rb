#!/usr/bin/env ruby
require_relative 'common'

module SyncOriginalMusic
  class SyncOriginalMusic < Common
    def initialize(id, hostname_master, hostname_slave) # master: v5backup, slave: v5db
      @id = id
      ip_master = self.to_ip(hostname_master)
      ip_slave = self.to_ip(hostname_slave)
      @result_master  = self.mysql_select(ip_master)
      @result_slave = self.mysql_select(ip_slave)
    end
    def record_to_insert
      self.result
      record_to_insert = Marshal.load(
        Marshal.dump(@result_master)
      ).reject { |k, v| @result_slave.has_key?(k) }

      record_to_insert.each do |k1, v1|
        v1.each do |k2, v2|
          if v2.nil?
            v1[k2] = "NULL"
          else
            v1[k2] = "'#{v2}'"
          end
        end
      end
      return record_to_insert
    end
    def record_to_update
      self.result
      record_to_update = Marshal.load(
        Marshal.dump(@result_master) 
      ).select { |k, v| @result_slave.has_key?(k) }

      record_to_update.each do |k1 ,v1|
        v1.delete_if do |k2, v2|
          v2 == @result_slave[k1][k2]
        end
      end

      record_to_update.delete_if { |k, v| v.empty? }

      record_to_update.each do |k1, v1|
        v1.each do |k2, v2|
          if v2.nil?
            v1[k2] = "NULL"
          else
            v1[k2] = "'#{v2}'"
          end
        end
      end
      return record_to_update
    end
    def file_to_sync
      self.result
      file_to_sync = []
      Marshal.load( Marshal.dump(@result_master) ).each_value do |v|
        $fields_filepath.each do |f|
          file_to_sync << v[f] unless v[f].nil?
        end
      end
      return file_to_sync
    end

  end
end



