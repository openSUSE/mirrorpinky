 Mirrorpinky
=============

 How it should work
--------------------

* Each user is member of a group
* Each group can have multiple servers (this is useful for cases like
  rackspace/gwdg with 3 mirrors)
* Each group can only modify/query their own servers
* Each user can query the public information about every other mirror
  (the stuff we show on mirrors.opensuse.org)

 Things groups can do
----------------------

* They can add new mirrors
* They can remove their mirrors
* They can disable/enable their mirror
* They can edit the various URLs assigned to their mirror (FTP, HTTP, RSYNC)
* They can set the priority of their mirror
  * This has to be carefully monitored, a bad mirror might set themselves a very
    high priority but is actually degrading the service for openSUSE users.
* They can edit the limitations for their mirrors. This includes:
  * Limit to network/AS/country/region
  * Allow serving other countries
* They should be able to see the log of the last scan of their mirror
* They should be get notifications in case we see errors with their mirror
  * It might a good idea to add arbitrator hosts outside of our network to avoid
    issues where only our connection to them is bad.
    * I think the arbitrator becomes more important when we start notifying
      people... disabling a mirror for a few minutes in case of a problem is one
      thing ... spamming users with false alarms another.


 TODO
------
* how to join an existing group

 Links collection
------------------

 Bugs
======

* [rubygem-GeoIP IPv6 support](https://github.com/cjheath/geoip/issues/17)

 CanCan
========

* [Defining Abilities](https://github.com/ryanb/cancan/wiki/defining-abilities)
* [Debugging Abilities](https://github.com/ryanb/cancan/wiki/Debugging-Abilities)
* [Nested Resources](https://github.com/ryanb/cancan/wiki/Nested-Resources)
* [Authorizing Controller Actions](https://github.com/ryanb/cancan/wiki/authorizing-controller-actions)
* [Non RESTful Controllers](https://github.com/ryanb/cancan/wiki/Non-RESTful-Controllers)

 Misc
======

* [Bootstrap Forms](http://getbootstrap.com/css/#forms)
* [Mirrorbrain and mirrors with multiple IPs](http://mirrorbrain.org/archive/mirrorbrain/0042.html)

 Deployment
------------

- svn co http://svn.mirrorbrain.org/svn/mirrorbrain/trunk/mb/famfamfam_flag_icons/ app/assets/images/famfamfam_flag_icons/
