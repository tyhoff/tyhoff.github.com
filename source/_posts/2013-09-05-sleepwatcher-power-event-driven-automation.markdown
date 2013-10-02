---
layout: post
title: "Sleepwatcher : Run Script on Sleep"
date: 2013-09-05 15:31
comments: true
categories: 
- mac
- osx
- scripts
---
[Sleepwatcher](http://www.bernhard-baehr.de/) is a Mac OS X background daemon that can trigger a script to run when various power related events occur, such as the laptop sleeping or waking up, the screen dimming, or power adapter being connected or disconnected. 

On my personal laptop, I have an AppleScript set up within sleepwatcher that mutes the audio each time the laptop goes to sleep. This is to prevent accidental audio playing during meetings and classes. 

<!-- more -->

## Setup ##
Below is setup script for sleepwatcher that I have written that installs it automatically as a system wise daemon.

{% include_code sleepwatcher.sh %}

The script begins with deleting any old version of sleepwatcher on the computer. It them moves onto downloading the package and copying the files into the appropriate places. It loads the launch daemon then creates two files, `/etc/rc.sleep` and `/etc/rc.wakeup`. These get run at their respective times, when the laptop is going to sleep or waking up.

My personal `/etc/rc.wakeup` script is shown below. All it does is run the short AppleScript command of setting the volume to zero. To get this functionality on your computer, just copy the code below into your own `/etc/rc.wakeup`.
```bash /etc/rc.wakeup
#!/bin/sh
osascript -e 'set volume 0'
```

Other possible uses for sleepwatcher include updating a DNS record on wakeup, opening up specific applications for a user, and of course running another script of the user's choice.

