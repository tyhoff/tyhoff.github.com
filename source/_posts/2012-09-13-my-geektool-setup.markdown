---
layout: post
title: "My GeekTool Setup"
date: 2012-09-13 16:49
comments: true
categories: 
- mac
- osx
- geektool
- scripts
---
My GeekTool setup is meant strictly for productivity. There are no pretty pictures, no cool meters or text or color. It is in a monospace font that allows for simple formatting, and it gets the job done...well. Here it is:

{% img center /images/posts/geektool.png %}

<!-- more -->

The GeekTool picture above has the following elements:

- Shuffle status of iTunes on the current playlist
- iTunes current volume
- Hard drive space remaining on internal SSD
- CPU top 2 processes
- Fan speed and CPU temperature
- Current iTunes song

I can't take a screenshot of my entire desktop, because the resolution on the MBPr is too large, but here is an old image.

[{% img center http://i.imgur.com/IXoU9.png Alt text %}](http://i.imgur.com/IXoU9.png)

The reason for this setup is so that I can always see my GeekTool information. If I maximize Chrome or any other application, the Dock prevents it from maximizing the entire screen, leaving the black sliver with my GeekTool in sight. I can always know if a process is consuming too much CPU, if my computer is getting hot, and the current song. 

##How To - AppleScript##

AppleScript is needed for some GeekTool scripts because it allows easy interfacing with applications to get data to display. The two examples below show the internal iTunes volume and the current playing song.

<br>
###iTunes Volume###
The first AppleScript we will look at the percent status of the internal iTunes volume. It is nothing too fancy.

```
if appIsRunning("iTunes") then
	tell application "iTunes"
		"iTunes:  " & sound volume & "%"
	end tell
end if

# method that checks if the application is running
on appIsRunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appIsRunning
```
<br>
###Current Song###
A more complicated one is the current song status. 
```
if not appIsRunning("BetterTouchTool") then
	tell application "BetterTouchTool" to activate
end if



if appIsRunning("iTunes") then
	tell application "iTunes"
		
		if player state is paused then
			name of current track & "
" & artist of current track & "
" & album of current track & " | " & (round (((player position) / (duration of current track)) * 100)) & "% - P"
			
		else if player state is not stopped and player state is playing then
			name of current track & "
" & artist of current track & "
" & album of current track & " | " & (round (((player position) / (duration of current track)) * 100)) & "%"
		end if
		
		
	end tell
end if

on appIsRunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appIsRunning
```

Now, pasting these isn't helping much. It does however give you an idea about what AppleScript is and possibliy gives you an idea of what can be accomplished. This is a GeekTool thread, so I am going to finish out with how to set up GeekTool specifically.

##How To - GeekTool##
1. Download and install [GeekTool](http://itunes.apple.com/us/app/geektool/id456877552?mt=12 ) from the Mac App Store.
2. Browse through the [Geeklets](http://www.macosxtips.co.uk/geeklets/) webpage to get some ideas.
3. Continue scrolling and download ALL THE LINKS!


####AppleScripts####

To use these, download an AppleScript, place it in a folder in which it will never be moved. I store my AppleScripts in <code>~/Documents/Scripts/</code>. 

Within GeekTool, create a new shell Geeklet. In the 'command' box, put 
```bash
osascript /path/to/file.scpt

#in my case
osascript ~/Documents/Scripts/iTunesvol.scpt
```

[iTunesvol.scpt](/downloads/geektool/iTunesvol.scpt) - outputs the current internal iTunes volume.

[shuffstatus.scpt](/downloads/geektool/shuffstatus.scpt) - outputs 'Yes' or 'No' depending on shuffle status of current playlist.

[currentsong.scpt](/downloads/geektool/currentsong.scpt) - outputs information about current playing song in iTunes.

<br>
####Fan Speeds / Internal Temperatures####
This next file is an application that is run with a terminal command, or in our case, through GeekTool. Place it in a place that you won't ever need to move it. 

Within GeekTool, create a new shell Geeklet. In the 'command' box, put 
```bash
/path/to/fans_tempsMonitor

#example
~/Documents/Scripts/fans_tempsMonitor
```

If that doesn't work, then you may need to execute this command before it.
```bash
chmod +x /path/to/fans_tempsMonitor
```

[fans_tempsMonitor](/downloads/geektool/fans_tempsMonitor) - shell application that outputs fan speeds and internal computer temperatures.


####Top CPU Processes####
This one is easy. Just download the Geeklet, double click on it, and it will install automatically.

[top.glet](/downloads/geektool/top.glet) - Geeklet that outputs the 2 top processes by CPU %.

####Tips and Hints####
I use the font Monaco size 11. It is monospace, which makes it very easy to format and make everything stay in line. I use a generic black background with white text. 

The one thing I have noticed with other peoples' AppleScripts is that they use variables. I did not like this solution because the AppleScripts would store some type of temporary variable in them and it would change the file somehow. This caused Dropbox to need to sync the file each time the AppleScript was run.

I solved this problem by not using variables. It is especially messy in current_song.scpt, but it works. 





