---
layout: post
title: "Install Deluge - Ubuntu Headless"
date: 2012-04-11 00:41
comments: true
categories: 
- ubuntu
- vps
---


This guide is about how to install [Deluge](http://dev.deluge-torrent.org/wiki/About). More specifically, since this is going to be installed on an Ubuntu 11.10 VPS, only the daemon and Web UI are going to be installed because there is no need for a GUI. I will also cover how to set up the Thin Client so that you can remotely control the daemon using a native application on your client computer. 

###There are 3 parts to this guide###
1. Installing the Daemon
2. Setting up the Web UI
3. Connecting using the Thin Client

<!--more-->

###Installing the Daemon###
We are going to add the Deluge repository, because the version of Deluge located in the default one is usually outdated. Notice <code>deluge</code> isn't included here because we do not want the GUI version of deluge, only the daemon and Web UI.
``` bash
$ sudo add-apt-repository ppa:deluge-team/ppa
$ sudo apt-get update
$ sudo apt-get install deluged deluge-webui deluge-console
```
If the <code>add-apt-repository</code> command did not work, run the following code and try then again.
``` bash
$ sudo apt-get install python-software-properties
```

To run the daemon when the computer boots, you must copy the following script to <code>/etc/default/deluge-daemon</code>. You need to add the username that the program is to be run as between the quotation marks after <code>DELUGED_USER</code>.
``` bash /etc/default/deluge-daemon
# Configuration for /etc/init.d/deluge-daemon

# The init.d script will only run if this variable non-empty.
DELUGED_USER=""             # !!!CHANGE THIS!!!!

# Should we run at startup?
RUN_AT_STARTUP="YES"
```
You need to place the following script in <code>/etc/init.d/deluge-daemon</code>.
``` bash /etc/init.d/deluge-daemon
#!/bin/sh
### BEGIN INIT INFO
# Provides:          deluge-daemon
# Required-Start:    $local_fs $remote_fs
# Required-Stop:     $local_fs $remote_fs
# Should-Start:      $network
# Should-Stop:       $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Daemonized version of deluge and webui.
# Description:       Starts the deluge daemon with the user specified in
#                    /etc/default/deluge-daemon.
### END INIT INFO

# Author: Adolfo R. Brandes 

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DESC="Deluge Daemon"
NAME1="deluged"
NAME2="deluge"
DAEMON1=/usr/bin/deluged
DAEMON1_ARGS="-d"             # Consult `man deluged` for more options
DAEMON2=/usr/bin/deluge-web
DAEMON2_ARGS=""               # Consult `man deluge-web` for more options
PIDFILE1=/var/run/$NAME1.pid
PIDFILE2=/var/run/$NAME2.pid
UMASK=022                     # Change this to 0 if running deluged as its own user
PKGNAME=deluge-daemon
SCRIPTNAME=/etc/init.d/$PKGNAME

# Exit if the package is not installed
[ -x "$DAEMON1" -a -x "$DAEMON2" ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$PKGNAME ] && . /etc/default/$PKGNAME

# Load the VERBOSE setting and other rcS variables
[ -f /etc/default/rcS ] && . /etc/default/rcS

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
. /lib/lsb/init-functions

if [ -z "$RUN_AT_STARTUP" -o "$RUN_AT_STARTUP" != "YES" ]
then
   log_warning_msg "Not starting $PKGNAME, edit /etc/default/$PKGNAME to start it."
   exit 0
fi

if [ -z "$DELUGED_USER" ]
then
    log_warning_msg "Not starting $PKGNAME, DELUGED_USER not set in /etc/default/$PKGNAME."
    exit 0
fi

#
# Function that starts the daemon/service
#
do_start()
{
   # Return
   #   0 if daemon has been started
   #   1 if daemon was already running
   #   2 if daemon could not be started
   start-stop-daemon --start --background --quiet --pidfile $PIDFILE1 --exec $DAEMON1 \
      --chuid $DELUGED_USER --user $DELUGED_USER --umask $UMASK --test > /dev/null
   RETVAL1="$?"
   start-stop-daemon --start --background --quiet --pidfile $PIDFILE2 --exec $DAEMON2 \
      --chuid $DELUGED_USER --user $DELUGED_USER --umask $UMASK --test > /dev/null
   RETVAL2="$?"
   [ "$RETVAL1" = "0" -a "$RETVAL2" = "0" ] || return 1

   start-stop-daemon --start --background --quiet --pidfile $PIDFILE1 --make-pidfile --exec $DAEMON1 \
      --chuid $DELUGED_USER --user $DELUGED_USER --umask $UMASK -- $DAEMON1_ARGS
   RETVAL1="$?"
        sleep 2
   start-stop-daemon --start --background --quiet --pidfile $PIDFILE2 --make-pidfile --exec $DAEMON2 \
      --chuid $DELUGED_USER --user $DELUGED_USER --umask $UMASK -- $DAEMON2_ARGS
   RETVAL2="$?"
   [ "$RETVAL1" = "0" -a "$RETVAL2" = "0" ] || return 2
}

#
# Function that stops the daemon/service
#
do_stop()
{
   # Return
   #   0 if daemon has been stopped
   #   1 if daemon was already stopped
   #   2 if daemon could not be stopped
   #   other if a failure occurred

   start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --user $DELUGED_USER --pidfile $PIDFILE2
   RETVAL2="$?"
   start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --user $DELUGED_USER --pidfile $PIDFILE1
   RETVAL1="$?"
   [ "$RETVAL1" = "2" -o "$RETVAL2" = "2" ] && return 2

   rm -f $PIDFILE1 $PIDFILE2

   [ "$RETVAL1" = "0" -a "$RETVAL2" = "0" ] && return 0 || return 1
}

case "$1" in
  start)
   [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME1"
   do_start
   case "$?" in
      0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
      2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
   esac
   ;;
  stop)
   [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME1"
   do_stop
   case "$?" in
      0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
      2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
   esac
   ;;
  restart|force-reload)
   log_daemon_msg "Restarting $DESC" "$NAME1"
   do_stop
   case "$?" in
     0|1)
      do_start
      case "$?" in
         0) log_end_msg 0 ;;
         1) log_end_msg 1 ;; # Old process is still running
         *) log_end_msg 1 ;; # Failed to start
      esac
      ;;
     *)
        # Failed to stop
      log_end_msg 1
      ;;
   esac
   ;;
  *)
   echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
   exit 3
   ;;
esac

:
```
Make the script executable and set to run on startup.
``` bash
sudo chmod 755 /etc/init.d/deluge-daemon
sudo update-rc.d deluge-daemon defaults
```

This following two commands are used to initialize files before editing them in the later steps.
```bash
sudo invoke-rc.d deluge-daemon start
sudo /etc/init.d/deluge-daemon stop
```

To be able to access the daemon from the local Deluge application on your computer, we need to enable remote access. You must now run <code>deluge-console</code> from the user prompt that you want to run Deluge as (same as the username you put in the script above). 
```bash
deluge-console
```
Once inside the console type the following
```bash
config -s allow_remote True
```

To configure a username and password for login to the Deluge server, use the following command, changing out the values to make it your own username and password. These are not related in any way to the Ubuntu username and password.
```bash
echo "username:password:10" >> ~/.config/deluge/auth
```

Start the daemon, and everything should be configured
``` bash
sudo /etc/init.d/deluge-daemon start
```

###Ending Words###
You are now able to access the WebUI at <code>http://your.server.ip:8112</code>. The default password is deluge.

You are now able to login to the Deluge daemon using a thin client at <code>your.server.ip</code> and port <code>58846</code>. The username and password are what you set it as above. 

You can change all of the settings using the preferences in the thin client, such as ports and default directories. 


