---
layout: post
title: "Octopress: The Guide"
date: 2012-04-10 22:18
comments: true
categories: 
- coding
- vps
- ubuntu
---
Octopress is a blogging framework that doesn't use MySQL or PHP, and allows for quick, focused writing. It brings coders and hackers back to their roots. The benefits of [Octopress](http://octopress.org/) are numerous, but you are encouraged to go to its website and learn more.

The goal of this post is to allow anyone with a minimal programming background to set up and maintain an  blog. This website is run on an Ubuntu 11.10 VPS, so this guide will for Ubuntu installations. I opted to go with the all in one approach, everything that generates the website is located on the server.

###There are 4 parts to this guide.###
1. Installing RVM and Ruby
2. Installing Octopress
3. Configuring Apache
4. How to start blogging

<!--more-->

<br />
###Installing RVM and Ruby###
RVM is the Ruby Version Manager. I have found that RVM is easier to install than rbenv, but others might disagree.
``` bash
$ sudo apt-get update
$ sudo bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
$ umask g+w
$ source /etc/profile.d/rvm.sh
```
This next command will install all of the dependencies of Ruby. 
``` bash
$ sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
```
Replacing "user" with your UNIX login name will allow the user to edit the files in <code>/usr/local/rvm</code>. 
``` bash
$ sudo chown -R user:user /usr/local/rvm
```
Next, now that you have RVM installed, we can go ahead and install Ruby and set version 1.9.3 as the default version. (switch 1.9.3 with the current version if changed). The following command will take 15-20 minutes, so don't be afraid if it takes a while to finish.
``` bash
$ rvm install 1.9.3 && rvm use 1.9.3
$ ruby -v
```
The last command there should show <code>ruby 1.9.3p125</code> or something similar.

<br />
###Installing Octopress###
If at anytime during the next few steps RVM asks if you would like to trust the .rvmc file, you can safely say "yes"
``` bash
$ cd
$ git clone git://github.com/imathis/octopress.git octopress
$ cd octopress    
$ gem install bundler 
$ bundle install
$ rake install
```

This final step to get Octopress to install. This will build the files that are located in <code>/source/</code> and publish them into the <code>/public/</code> folder.  
``` bash
$ rake generate
```
<br />
###Configuring Apache###
I am going to assume that Apache is already working, meaning that if you typed in <code>127.0.0.1</code> or <code>localhost</code> into the browser of your server, or by typing in the IP of your VPS, you should see a "It Works" page. 

The first and only step is to change what directory Apache looks in to display the webpage. I am going to create a new webpage configuration with the name <code>mysite</code>. You may name it how you like and change out the name when applicable. 
``` bash
$ cd /etc/apache2/sites-available
$ sudo cp default mysite
```

Now you have to open the new configuration file with your favorite editor. I am going to use vim
```bash
$ sudo vim mysite
```
I put comments above the two lines that need to be changed. You need to change <code>/var/www</code> to the path of the Octopress public folder, which is most likely <code>/home/user/octopress/public</code>, where "user" is your UNIX username. 
``` xml /etc/apache2/sites-available/mysite
<VirtualHost *:80>
	ServerAdmin webmaster@localhost

	<!-- point the line below to Octopress's public folder -->
	DocumentRoot /path/to/octopress/public/folder    
	<Directory />
		Options FollowSymLinks
		AllowOverride None
	</Directory>

	<!-- point the line below to Octopress's public folder -->
	<Directory /path/to/octopress/public/folder >
		Options Indexes FollowSymLinks MultiViews
		AllowOverride None
		Order allow,deny
		allow from all
	</Directory>

	ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
	<Directory "/usr/lib/cgi-bin">
		AllowOverride None
		Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
		Order allow,deny
		Allow from all
	</Directory>

	ErrorLog ${APACHE_LOG_DIR}/error.log

	# Possible values include: debug, info, notice, warn, error, crit,
	# alert, emerg.
	LogLevel warn

	CustomLog ${APACHE_LOG_DIR}/access.log combined

    Alias /doc/ "/usr/share/doc/"
    <Directory "/usr/share/doc/">
        Options Indexes MultiViews FollowSymLinks
        AllowOverride None
        Order deny,allow
        Deny from all
        Allow from 127.0.0.0/255.0.0.0 ::1/128
    </Directory>

</VirtualHost>
```
The final thing to do is to restart Apache so that the changes show up
```bash
$ sudo service apache2 reload
```
There! Now if you go to the address of your webpage, you should see a generic Octopress page. If you don't, leave a comment and we will see what we can do.

<br />
###How to start blogging###
To insert a new post, type:
``` bash
$ rake new_post["post title"]
```
This will create a new file in the directory <code>/source/_posts/"date and name of post"</code>. You will need to edit this file using the [Markdown](http://daringfireball.net/projects/markdown/syntax) syntax. It is quite simple to understand and learn. 

Each time you create a new post, you can use the following command to update the webpage and push any changes to the public folder.
``` bash
$ rake generate
```
If you want to learn more about how to manage posts and create pages, please visit the Octopress page [Blogging Basics](http://octopress.org/docs/blogging/).
