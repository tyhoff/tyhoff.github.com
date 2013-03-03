---
layout: post
title: "Identites in Mountain Lion's Mail.app"
date: 2012-05-16 10:52
comments: true
categories: 
- mac
- osx
---

Identities, or E-mails aliases, allow someone to send emails through one SMTP server while using multiple E-mails addresses. This option is present in most of todays E-mails clients, except Apple's Mail.app 5.0 option is hidden. There is a way to set up identities, but it will require a little bit of plist editing. I will give an example setup to make it easier to follow. 

<!-- more -->

##First Steps##

Before we do anything, let's backup the file we will be editing.
```bash
cp ~/Library/Mail/V2/MailData/Accounts.plist ~/Library/Mail/V2/MailData/Accounts_backup.plist
```

Listed below is a primary email and two extra ones.
<pre>
Primary Gmail:   tyler@gmail.com
1st extra email: tyler@hotmail.com
2nd extra email: tyler.smith@yahoo.com
</pre>

I would like to be able to send E-mailss using the last two addresses but only use the SMTP servers fo the primary Gmail account. To make this possible, please look below and make sure your mail "Accounts" page looks similar to the one below. Note that this is basically the default setup for a single Gmail account on Mail.app. 
</br>
</br>
{% img center /images/posts/mail_accounts.png %}

The next step requires some plist editing. You are going to need to edit the file <code>~/Library/Mail/V2/MailData/Accounts.plist</code>. You can open it in Xcode if you have it or in a text editor. I will demonstrate both ways. 

##Xcode##
{% img center /images/posts/xcode_plist.png %}
Notice the default E-mails that was set up in Mail is listed as the "Email Address". Each alias has its own E-mails and name. Separate names are useful if you want to give your full name on some adresses and only your first on others. 

##Text Editor##
Follow the format below for each new alias.
```xml
<dict>
	<key>alias</key>
	<string>tyler@gmail.com</string>
	<key>name</key>
	<string>Tyler</string>
</dict>
```
Below is just a section of the <code>Accounts.plist</code> file, but it is enough for you to know where to place the edits. 

```xml /Library/Mail/V2/MailData/Accounts.plist
<key>DaysBetweenSyncs</key>
<integer>1</integer>
<key>DraftsMailboxName</key>
<string>Drafts</string>
<key>EmailAddresses</key>
<array>
	<string>tyler@gmail.com</string>
</array>

<!-- Below is the edited part -->

<key>EmailAliases</key>
<array>
	<dict>
		<key>alias</key>
		<string>tyler@gmail.com</string>
		<key>name</key>
		<string>Tyler</string>
	</dict>
	<dict>
		<key>alias</key>
		<string>tyler@hotmail.com</string>
		<key>name</key>
		<string>Tyler S</string>
	</dict>
	<dict>
		<key>alias</key>
		<string>tyler.smith@yahoo.com</string>
		<key>name</key>
		<string>Tyler Smith</string>
	</dict>
</array>

<!-- Above is the edited part -->

<key>FullUserName</key>
<string>Tyler Smith</string>
<key>GmailCapabilitiesSupport</key>
<integer>2</integer>
```
You are now done. If you quit Mail and open a "New Message", you will see an option to select multiple email addresses to send from, each with their own names. 

{% img center /images/posts/mail_goal.png %}