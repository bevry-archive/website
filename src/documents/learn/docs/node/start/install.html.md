---
title: "Install Node.js"
---

This is Bevry's supported guide for installing [Node.js](http://nodejs.org/) on your coputer as well as any other required dependencies for your particular system. It may seem seem a bit intimidating, but it's actually really easy and only takes a few minutes.


## On OSX

1. ### [Download & Install Git](http://git-scm.com/download)

2. ### [Download & Install Xcode](http://developer.apple.com/xcode/)

	Once installed, you'll have to install the command line tools. To do this, open Xcode and go to `Preferences -> Downloads -> Command Line Tools -> Install`

	If you installed Xcode over a old non app store version, you'll want to run the follow to ensure everything is pointing to the new xcode location: `sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer`

3. ### Install Node.js

	#### Via the Node.js Official Installer

	1. The simplest and official way to install Node.js

	1. Uninstall any previous Node.js versions you may already have

	1. [Download & Install Node.js](http://nodejs.org/#download)


	#### Via [Node Version Manager](https://github.com/creationix/nvm)

	1. NVM allows you to run multiple Node.js versions on the same machine

	1. Uninstall any previous Node.js versions may already have

	1. Prepare Permissions

		``` bash
		sudo chown -R $USER /usr/local
		```

	1. Install NVM

		1. Clone NVM

			``` bash
			git clone git://github.com/creationix/nvm.git ~/.nvm
			```

		2. Add the following to your `~/.bashrc` file

			``` bash
			# NVM
			if [ -s ~/.nvm/nvm.sh ]; then
				source ~/.nvm/nvm.sh
			fi
			```

		3. Open a new terminal window or run `source ~/.nvm/nvm.sh`

	1. Install Node.js

		``` bash
		nvm install v0.8.9
		nvm alias default 0.8
		nvm use 0.8
		```


	#### Via Direct Install

	1. It's the most robust solution, but also requires the most maintenance

	1. Run the following

		``` bash
		export node_version_to_install='v0.8.9'
		curl https://raw.github.com/bevry/community/master/install-node/install-node.sh | sh
		```


## On Apt Linux (e.g. Ubuntu)

1. Run the following

	``` bash
	sudo apt-get update && sudo apt-get install curl build-essential openssl libssl-dev git python
	export node_version_to_install='v0.8.9'
	curl https://raw.github.com/bevry/community/master/install-node/install-node.sh | sh
	```


## On Yum Linux (e.g. Fedora)

1. Run the following

	``` bash
	sudo yum -y install tcsh scons gcc-c++ glibc-devel openssl-devel git python
	export node_version_to_install='v0.8.9'
	curl https://raw.github.com/bevry/community/master/install-node/install-node.sh | sh
	```


## On Windows

Node.js has been stable on Window since version 0.6, here are the official installation instructions:

1. ### [Download & Install Git](http://git-scm.com/download)

	IMPORTANT. When installing, make sure you install with the option of making git available to the windows command line.

2. ### [Download & Install Node.js](http://nodejs.org/#download)

