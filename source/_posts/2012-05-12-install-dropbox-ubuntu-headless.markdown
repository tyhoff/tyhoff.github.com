---
layout: post
title: "Install Dropbox - Ubuntu Headless"
date: 2012-05-12 11:28
comments: true
categories: 
- ubuntu
- vps
---
This guide is about how to install Dropbox and its CLI (command line interface) on an Ubuntu server. Specifically, I am using a BuyVM Ubuntu 11.10 VPS without a GUI. An important note is that Dropbox increased my RAM usage by ~150MB, even while idling. This installation is probably not suited for a computer with 256MB or less. 
 
<!--more-->

The next two commands will download Dropbox and install it to the root of the home directory of the current user. 
```bash
wget -O ~/dropbox.tar.gz "http://www.dropbox.com/download/?plat=lnx.x86"
tar -xzvf ~/dropbox.tar.gz
```

Start the daemon for the current user 
```bash
~/.dropbox-dist/dropboxd
```

What will happen now is the terminal will output a website URL that you will need to navigate to using an internet browser. This is to link the installation to your Dropbox account. YOU MUST LEAVE THE PROGRAM RUNNING WHILE GOING TO THE WEBSITE. 

Once you have finished this step, Dropbox will say is has been successful with linking. You may hit <code>CTRL-C</code> now to stop the program.

Currently, we now have new folder, <code>~/Dropbox</code>. 

We are now going to install the CLI for Dropbox, because it will make our lives much easier.

```bash
wget -O ~/.dropbox/dropbox.py "http://www.dropbox.com/download?dl=packages/dropbox.py"
chmod 755 ~/.dropbox/dropbox.py 
```

Now we need to start Dropbox, and let it initialize some of the folders and files so we can apply settings to them. 

```bash
~/.dropbox/dropbox.py start
```

To have Dropbox start when the system is booted, we are going to edit the crontab. Usually, scripts are placed in init.d, but the script never worked for me on Ubuntu 11.10. 

Open the crontab by typing
```bash
crontab -e
```

Add <code>@reboot ~/.dropbox-dist/dropboxd</code> somewhere in the file on its own line. 

Make sure cron is configured correctly to start up on a reboot.
```bash
update-rc.d cron defaults
```

In my experience, it is now best to reboot the server. If I did not restart the computer now, I was not able to configure my Dropbox installation using the CLI we downloaded. It would always give me the error "Dropbox is not responding"


To find out what the CLI can do, you can type 
```bash
~/.dropbox/dropbox.py help
```

To exclude specific folders, you can type 
```bash
~/.dropbox/dropbox.py exclude add ~/Dropbox/folder
```

There you have it. Dropbox is now installed, it runs when the computer is booted using a cron command, and you can only sync the folders that you want.

