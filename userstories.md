# MirrorPinky user stories / action items

## General

* all operations of logged in users should be tracked in an audit log and in special cases cause a notification

## anonymous user

* can browse the server listing (with various filters)
  * can download the squid ACL (technically just a plain text version of the above)
* can login to the site
* can search for a file, a distribution or a marker and get's a list of all mirror servers for his region/country (#2)
* can filter for distributions
* can sort inside the table

## logged in user

* can have different roles
  * admin (mirrorbrain admin)
  * user  (mirror admin)

### admin user

* can manage everything
  * should be able to do everything that the mb cmdline tool can:
    * edit all fields of all mirrors
    * enable/disable a mirror
  * mb tool might need to be enhanced for group handling
* can approve requests

### normal user

* can request a new group
* can request servers for a group
* can request acls for a server
* can add other people to his group
* can edit his own server details
* can remove ACLs of his own server
* can remove servers from his group
* can remove users from his group
* can request a scan of his mirror
* can view the log file of the last scan of his mirror
* can not do the last 6 actions for entities he doesnt own.

## current implementation

### adding a server

* user logs in
* clicks on "Administer your servers"
* Requests new group
* once the group is approved he can start adding servers

## future

### adding server

* user signs up
* clicks on "Administer your servers"
* Requests new group
* Can immediately request a server for this group by clicking "Add mirror"
* needs to enter the following fields
  * operator name
  * admin name
  * admin email
  * base url http
* can optionally enter
  * operator url
  * max file size in bytes
  * score
  * flags for region only, country only, AS only, prefix only
  * base url ftp
  * base url rsync
  * public notes
* click submit
* server can only be saved if all required fields are present and we can resolve the baseurl and map the IP to an AS,
  * if not we return to the create view including an error message
* once the server is saved rsync ACLs can be requested
* request rsync ACLs with "Request a new ACL entry"
* enter IP address/hostname
  * click submit

### editing server by user

* user signs up
* clicks on "Administer your servers"
* clicks on the server inside the group
* can change/edit the following fields without further approval:
  * operatorName
  * operatorUrl
  * baseurl
  * baseurlFtp
  * baseurlRsync
  * regionOnly
  * countryOnly
  * asOnly
  * prefixOnly
  * otherCountries
  * fileMaxsize
  * publicNotes
  * enabled/disabled
  * admin
  * adminEmail
  * comments- the following changes will create a request (means: are not effective immediately):
* changing rsync ACLs
* score -> too much abuse potential

### deleting a server by user #1

* ACLs will be removed
* in effect immediately with notification

### deleting a group by user #1

* in effect immediately with notification

### deleting a server by admin #1

* should be done immediately (notify to user)
* all entries should be pruned of the database
  * ACLs will be removed

### deleting a group by admin #1

* should be done immediately (notify to user ?)
* all servers and the group should be deleted
  * ACLs will be removed

### thoughts on the process

* generate identifier from baseurl? That's what we do at the moment, so a strong argument for "yes".
* wizard style approach? (or interactive through js)
  * enter baseurl
  * send baseurl to server and run "extract information" step on it
  * present admin data and ask for verification
  * present admin view with the baseurl with check box to enable a protocol and button to change the url from the proposed pattern.
  * show forms for the metadata like admin name/email, operator name/url
    * seed admin name/email from user?

* technical implementations
  * drop request models, add approved flag to the real models
    * this requires adapting the server table which is owned by mirrorbrain
    * this requires adapting the query that mod\_mirrorbrain uses to add a "and approved = true" flag to it.
    * this requires adapting the query that the scanner uses to add a "and approved = true" flag to it.
    * instead of the approved flag -> active flag
   * handle repo pusher config here?
 * checking submitted rsync ACLs needs approval
   * sanity checks like "is the IP in the same prefix/AS as the server"

* how to handle ACL only requests

## group mgmt

### add user

* user needs to be logged in
* clicks on "Administer your servers"
* clicks "Add user" for the respective group
* enters the login name of another user
  * other user has to exist
    * do we want to support search, might leak informations about other users.