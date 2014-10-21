1. add devel:languages:ruby:extensions for your distro
2. zypper in rubygem-bundler ruby-devel rubygem-pg
3. cd into your GIT checkout directory
4. bundle install --path=bundle
5. rails c # for the Rails console
6. rails s # to start the builtin webserver
