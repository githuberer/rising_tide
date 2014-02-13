#!/usr/bin/env ruby
params = {"myfile"=>{:filename=>"test.txt", :type=>"text/plain", :name=>"myfile", :head=>"Content-Disposition: form-data; name=\"myfile\"; filename=\"test.txt\"\r\nContent-Type: text/plain\r\n"}, "path"=>" /u/bak/test.txt", "hostname"=>["v5backup", "v5file"], "commit"=>"subfile", "result"=>[8, [nil, nil, nil], [nil, nil, nil]]}


upload_web_result = params["result"].shift
if upload_web_result == 8
    (0...params["result"].length).each do |e|
    puts "hostname : #{params["hostname"][e]}"
    result0 = params["result"][e][0]
    result1 = params["result"][e][1]
    result2 = params["result"][e][2]
    if result0 == nil and result1 == nil and result2 == nil
      puts "result : ok"
    else
      puts <<-header
      error message0: #{result0}
      error message1: #{result1}
      error message2: #{result2}
      header
    end
  end
else puts "upload error message: #{upload_web_result}"
end

