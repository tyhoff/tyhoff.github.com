---
layout: post
title: "Sleepwatcher : Run Script on Sleep"
date: 2013-10-01 15:31
comments: true
categories: 
---

[Sleepwatcher](http://www.bernhard-baehr.de/) is a Mac OS X background daemon that can trigger a script to run when various power related events occur, such as the laptop sleeping or waking up, the screen dimming, or power adapter being connected or disconnected. 

On my personal laptop, I have an AppleScript set up within sleepwatcher that mutes the audio each time the laptop goes to sleep. This is to prevent accidental audio playing during meetings and classes. 

Below is setup script for sleepwatcher that I have written that installs it automatically as a system wise daemon. It also sets up the event that mutes the laptop audio on sleep. 


{% include_code sleepwatcher.sh %}

The script begins with deleting any old version of sleepwatcher on the computer. It them moves onto downloading the package and copying the files into the appropriate places. It loads the launch daemon then creates two files, `/etc/rc.sleep` and `/etc/rc.wakeup`. These are run at their respective times, when the laptop is going to sleep or waking up.

My `/etc/rc.wakeup` script is shown below. All it does is run the short AppleScript command of setting the volume to zero. 
```bash
#!/bin/sh
osascript -e 'set volume 0'
```

Other uses for sleepwatcher include updating a DNS record on wakeup, opening up specific applications for a user, and of course running another script of the user's choice