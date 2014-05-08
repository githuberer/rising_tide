Rising-tide Manager
===========
Please run command in the application root directory unless otherwise specified.


System environment initialize
-----------
For Ubuntu/Debian user
``` shell
aptitude -y install dirname realpath
aptitude -y install imagemagick libmagickwand-dev
```
For CentOS/Redhat user
``` shell
yum -y install dirname realpath
yum -y install ImageMagick-devel
```


Ruby environment initialize
-----------
```shell
gem install bundler
gem install rmagick
bundle install
```


Configure
-----------
```shell
mv config/main_example.rb config/main.rb
```
And then, modify this file(config/main.rb) according to the specific environment.


Run it
-----------
```shell
./init.sh start
./init.sh stop
./init.sh restart
```



