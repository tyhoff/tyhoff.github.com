---
layout: post
title: "Quality of Service in Tomato"
date: 2013-10-01 19:22
comments: true
categories: 
- tomato
- networking
---

Tomato is an open-source router firmware for many of today's routers. I personally have it installed on my Asus RT-N16 router, and I love it. I've had it running on the router for more than two years, but I just recently discovered one of its best features, Quality of Service. 

In a nutshell, Quality of Service in a router deals with prioritizing certain traffic over other kinds and sometimes limiting the overall bandwidth of connections to and from the Internet. The benefit of this is so that roommate who always torrents won't have a direct affect on how fast your Internet browsing is since the torrent download would have a lower priority.

<!-- more -->

Now, my QoS has a very simple rulebook. I live in an apartment with 3 other roommates, and the only time problems arise is when Netflix is being used or the games from NBA.com are being streamed. I also torrent a little (Raspberry Pi and Ubuntu installation iso's), so I made sure to limit myself on those downloads as well. If you want a definitive guide about how to set up the QoS settings, follow the link below. It is a lengthy read.

[Using Tomato's QOS System](http://tomatousb.org/tut:using-tomato-s-qos-system)

### How to set it up in Tomato ###

1. Go to [Speedtest.net](http://speedtest.net) and get record your Internet speed. Mine is below.

	{% img center /images/posts/speedtest.png %}

	My bandwidth is approximately 25 Mbit/s downlink and 6 Mbit/s uplink. This is equivalent to 25,000 kbit/s and 6,000 kbit/s (You'll need this for the next step).

2. Next, navigate to your Tomato router configuration website, and in the left menu, click "QoS -> Basic Settings".

3. Under the section Outbound Rate / Limit, fill in the Max Bandwidth, which is your uplink speed from your Speedtest.net multiplied by 70-80%. Make sure to convert it to kbit/s.

4. Under the section Inbound / Limit, fill in the Max Bandwidth, which is your downlink speed from your Speedtest.net multiplied by 70-80%. Make sure to convert it to kbit/s.

5. Within both sections, you will find classifications for different types of traffic (high, medium, low, etc). In my setup, I only used High, Medium, and Low to keep it simple. Each section got an appropriate amount of bandwidth percentage I felt was necessary. In Outbound, the left column is the minimum and the right is the maximum. Under Inbound, the only column is maximum. Decide on how you'll prioritize your traffic using the dropdown menus. Mine is below.
	- High : HTTP traffic and DNS requests (Internet browsing)
	- Medium: HTTP Downloads (Netflix, NBA, direct downloads)
	- Low: Bittorrent 

6. Click Save

7. Click "Classification" in the left menu.

	{% img center /images/posts/tomato_qos1.png %}

8. Fill in the chart with the things you would like to prioritize and limit. 

	{% img center /images/posts/tomato_qos2.png %}

9. Click Save

10. Go back to "Basic Settings" and click Enable at the top. 

11. Click Save. 

You now have a useful Tomato QoS setup. Make sure to experiment with it so you get the best results.




