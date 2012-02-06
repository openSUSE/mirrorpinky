# vim: set sw=2 sts=2 et tw=80 :
# unicorn_rails -c /data/github/current/config/unicorn.rb -E production -D
base_dir = File.expand_path( File.dirname(__FILE__) + '/../')
Dir.chdir(base_dir)

rails_env = ENV['RAILS_ENV'] || 'production'

# 16 workers and 1 master
worker_processes (rails_env == 'production' ? 2 : 1)

# Load rails+github.git into the master before forking workers
# for super-fast worker spawn times
preload_app true

# Restart any workers that haven't responded in 30 seconds
timeout 30

socket_path = File.join(base_dir, '/tmp/sockets/unicorn.sock')
# Listen on a Unix data socket
listen socket_path , :backlog => 2048
# for easier local testing
# listen "127.0.0.1:3000", :backlog => 2048

##
# REE

# http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end


before_fork do |server, worker|
begin
  File.chmod(0660, socket_path)
  webserver_user, webserver_group = 'lighttpd', 'lighttpd'
  webserver_uid = Etc.getpwnam(webserver_user).uid
  webserver_gid = Etc.getgrnam(webserver_group).gid
  File.chown(webserver_uid, webserver_uid, socket_path)
rescue => e
  server.logger.info "Rescued: chmod/chown failed #{e.inspect}"
end

  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = File.join(Rails.root,'/tmp/pids/unicorn.pid.oldbin')
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end


after_fork do |server, worker|
  ##
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection

  ActiveRecord::Base.establish_connection
#  CHIMNEY.client.connect_to_server
  # Redis and Memcached would go here but their connections are established
  # on demand, so the master never opens a socket


  ##
  # Unicorn master is started as root, which is fine, but let's
  # drop the workers to git:git

  begin
    uid, gid = Process.euid, Process.egid
    user, group = 'lighttpd', 'lighttpd'
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
   #if Rails.env == 'development'
      server.logger.info "couldn't change user, oh well"
   #else
   #  raise e
   #end
  end
end
