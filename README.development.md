1. add devel:languages:ruby:extensions for your distro
2. zypper in rubygem-bundler ruby-devel rubygem-pg
3. git co git@github.com:openSUSE/mirrorpinky.git
4. cd into your GIT checkout directory
5. git submodule init && git submodule update
6. svn co http://svn.mirrorbrain.org/svn/mirrorbrain/trunk/mb/famfamfam_flag_icons app/assets/images/famfamfam_flag_icons
7. bundle install --path=bundle
8. rails c # for the Rails console
9. rails s # to start the builtin webserver
