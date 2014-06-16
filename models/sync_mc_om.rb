#!/usr/bin/env ruby
require_relative 'base'

class SyncMcOm
  #attr_reader :@records_to_insert, :@records_to_update, :@file_to_sync
  def initialize(ids)   # ids is an array
    # sync from master to slave  =example=>  master: v5backup, slave: v5db
    @master, @slave, @fileserver = to_ip($master), to_ip($slave), $fileserver
    @database, @table = $database, $table
    @fields = $fields
    @ids = ids
  end


  protected
  include Base
  def get_records(hostname)  # result is a hash
    result = mysql_select(hostname, @database, @table, @ids )  # @dis is an array
    records = {}
    result.each { |e| records[e.delete("om_id")] = e }
    # result["1211"] = { "type" => 0, "sing_num" => nil }; "1211" is an om_id
    records
    # result = { 1211 => { "type" => 0, "sing_num" => nil } }
  end

  def get_records_master
    @records_master = get_records(@master)
  end

  def get_records_slave
    @records_slave = get_records(@slave)
  end


  def get_records_to_insert
    get_records_master unless @records_master
    get_records_slave unless @records_slave
    @records_to_insert = Marshal.load(
      Marshal.dump(@records_master)
    ).reject { |k, v| @records_slave.has_key?(k) }
    @records_to_insert.each do |k1, v1|
      v1.each do |k2, v2|
        if v2.nil?
          v1[k2] = "NULL"
        else
          v1[k2] = "'#{v2}'"
        end
      end
    end
  end

  def get_records_to_update
    get_records_master unless @records_master
    get_records_slave unless @records_slave

    @records_to_update = Marshal.load(
      Marshal.dump(@records_master) 
    ).select { |k, v| @records_slave.has_key?(k) }

    @records_to_update.each do |k1 ,v1|
      v1.delete_if do |k2, v2|
        v2 == @records_slave[k1][k2]
      end
    end

    @records_to_update.delete_if { |k, v| v.empty? }

    @records_to_update.each do |k1, v1|
      v1.each do |k2, v2|
        if v2.nil?
          v1[k2] = "NULL"
        else
          v1[k2] = "'#{v2}'"
        end
      end
    end
  end


  def get_sqlcmds_to_insert
    get_records_to_insert
    @sqlcmds_to_insert = []

    @records_to_insert.each do |k1, v1|
      @sqlcmds_to_insert << <<-EOF
        INSERT INTO #{@table} (om_id, #{v1.keys.join(', ')}) VALUES ('#{k1}', #{v1.values.join(', ')})
      EOF
    end
  end

  def get_sqlcmds_to_update
    get_records_to_update
    @sqlcmds_to_update = []

    @records_to_update.each do |k1, v1|
      lists = []; v1.each { |k2, v2| lists << "#{k2} = #{v2}" }
      @sqlcmds_to_update << <<-EOF
        UPDATE #{$table} SET #{lists.join(', ')} WHERE om_id = #{k1}
      EOF
    end
  end


  def get_uris_to_syncfile
    get_records_master unless @records_master
    get_records_slave unless @records_slave
    @uris_to_syncfile = []

    Marshal.load( Marshal.dump(@records_master) ).each_value do |v|
      @fields.each { |f| @uris_to_syncfile << v[f] unless v[f].nil? }
    end
  end


  public
  def sync_records
    get_sqlcmds_to_insert
    re1 = mysql_query(@slave, @database, @sqlcmds_to_insert) unless @sqlcmds_to_insert.empty?  # @sqlcmds_to_insert is an array

    get_sqlcmds_to_update
    re2 = mysql_query(@slave, @database, @sqlcmds_to_update)  unless @sqlcmds_to_update.empty? # @sqlcmds_to_update is an array

    result = []
    result << re1 if re1
    result << re2 if re2
    result
  end


  def sync_files
    get_uris_to_syncfile
    shellcmds = []

    @uris_to_syncfile.each {|e| shellcmds << "sudo /u/shscript/syncfile_mc_om.sh #{e}" }
    ssh("#{shellcmds.join('; ')}", @fileserver)
  end
  #def test
  #get_sqlcmds_to_update
  #"aa" if @sqlcmds_to_update.empty?
  #end

end

