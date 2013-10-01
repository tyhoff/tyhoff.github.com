---
layout: post
title: "Access Purdue CS printers remotely"
date: 2013-04-26 13:15
comments: true
categories: 
- mac
- osx
- Purdue
- Lawson
---

{% img center /images/posts/lawson_printing0.png %}

This is a short tutorial about how to access and send jobs to the printers on the Purdue CS Network using a Mac. 

<!-- more -->

This is copied directly from the [Mac OS X Help pages](http://support.apple.com/kb/HT3049):

**Mac OS X v10.5 or later**

1. Choose **System Preferences** from the **Apple** menu.
2. Choose **Print & Fax** from the View menu.
3. Click the **+** button to add a printer.
4. Press the Control key while clicking the "Default" icon (or any other icon on the toolbar), then choose Customize Toolbar from the contextual menu that appears.
5. Drag the Advanced (gear) icon to the toolbar.
6. Click Done.
7. Click the Advanced icon that was added to the toolbar.
8. Choose Windows from the Type pop-up menu.
9. In the URL field, type the printer's address in one of the following formats:

>smb://cups.cs.purdue.edu/\<printer_name\>

10. In the Name field, type the name you would like to use for this printer in Mac OS X.
11. In the Use field, choose 'Generic PostScript Printer'
12. Click Add.

{% img center /images/posts/lawson_printing1.png %}
