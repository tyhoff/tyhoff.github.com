---
layout: post
title: "Remove Apache2 - Install NGINX"
date: 2012-04-10 22:21
comments: true
categories: 
- vps
- ubuntu
---
{% img center /images/posts/nginx.png %}

So you want to remove Apache2 in favor of NGINX? You've come to the right place. This is a quick and to the point guide that should get you up and running with NGINX in no time. I am using Ubuntu 11.10 on a VPS, but this should work for most installations of Ubuntu. NOTE: This guide does not include how to install PHP. I did not need it so I did not end up installing it.

<!--more-->

<br />
###Remove Apache2###
This first command will delete everything apache2 on the system. The second will delete the apache2 directory
``` bash
$ sudo apt-get remove --purge apache2 apache2-utils
$ sudo rm -rf /etc/apache2
```

<br />
###Install NGINX###
The following commands will add NGINX's repository so that you can install the most updated version. 
``` bash
$ sudo add-apt-repository ppa:nginx/stable
$ sudo apt-get update
$ sudo apt-get install nginx
```
If you get an error on the add-apt-repository command, execute the following command
``` bash
$ sudo apt-get install python-software-properties
```

<br />
###Configure NGINX###
Last thing we will need to do is to go to the configuration file for NGINX. It is located in <code>/etc/nginx/sites-available/default</code> This section is only the first part of the config file.
``` xml /etc/nginx/sites-available/default
server {
	#listen   80; ## listen for ipv4; this line is default and implied
	#listen   [::]:80 default ipv6only=on; ## listen for ipv6

	root /path/to/website/dir;
	index index.html index.htm;

	# Make site accessible from http://localhost/
	server_name localhost;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to index.html
		try_files $uri $uri/ /index.html;
		# Uncomment to enable naxsi on this location
		# include /etc/nginx/naxsi.rules
	}
```
You will need to change lines 5 and 6. Line 5 will need the path to the directory of your website, and line 6 will be the types of index files located in the directory, whether they are index.php, .html, .htm etc.

To restart NGINX and make your changes take effect, the command to restart the service is necessary.
``` bash
$ sudo /etc/init.d/nginx start
```

<br />
###Enjoy###
There you have it. The simplest guide I can make that shows how to uninstall Apache2 and install NGINX.