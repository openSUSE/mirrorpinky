1. add devel:languages:ruby:extensions for your distro
2. zypper in rubygem-bundler ruby-devel rubygem-pg
3. git co git@github.com:openSUSE/mirrorpinky.git
4. cd into your GIT checkout directory
5. git submodule init && git submodule update
6. bundle install --path=bundle
7. rails c # for the Rails console
8. rails s # to start the builtin webserver
