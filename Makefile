all:		
		rake generate
		rake preview

update:		
		rake generate
		rsync --delete --archive --verbose --update --compress --progress --exclude=".*" -e "ssh -i /Users/tyler/.ssh/bigmac_rsa" ~/Dropbox/extra/octopress/public/* vps:/var/www/
