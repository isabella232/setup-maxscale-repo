#!/bin/bash

path_to_repo=$1

if [[ -z "$path_to_repo" ]]; then
	path_to_repo="http://jenkins.engskysql.com/repository/develop/mariadb-maxscale/1.0/"
fi 

distro_name="centos"
maxdir="/usr/local/skysql/maxscale/repo-setup"

zypper --version 2> /dev/null > /dev/null
if [[ $? == 0 ]]; then
	# it is SUSE
	release_info=$(cat /etc/*-release 2>/dev/null)
	if [[ $(echo "$release_info" | grep 'VERSION = 13') != "" ]]; then
		# we have opensuse only for version 13 (should be fixed later)
                distro_name="opensuse"
		sed "s|####path_to_repo####|$path_to_repo|g" $maxdir/maxscale.repo.suse13.template > /etc/zypp/repos.d/maxscale.repo
	else
                distro_name="sles"
		if [[ $(echo "$release_info" | grep 'VERSION = 12') != "" ]]; then
			sed "s|####path_to_repo####|$path_to_repo|g" $maxdir/maxscale.repo.sles12.template > /etc/zypp/repos.d/maxscale.repo
		else
			sed "s|####path_to_repo####|$path_to_repo|g" $maxdir/maxscale.repo.sles11.template > /etc/zypp/repos.d/maxscale.repo
		fi
        fi
	rpm --import $path_to_repo/Maxscale-GPG-KEY.public
else
	yum --version 2> /dev/null > /dev/null
	if [[ $? == 0 ]]; then
		# there is YUM here
		release_info=$(cat /etc/*-release 2>/dev/null)
		if [[ $(echo "$release_info" | grep 'Red Hat') != "" ]]; then
			distro_name="rhel"
		fi
		if [[ $(echo "$release_info" | grep 'fedora') != "" ]]; then
        		distro_name="fedora"
		fi

		sed "s|####path_to_repo####|$path_to_repo|g" $maxdir/maxscale.repo.template | sed "s|####distro_name####|$distro_name|g"> /etc/yum.repos.d/maxscale.repo
	fi
fi

apt-get --version 2> /dev/null > /dev/null
if [[ $? == 0 ]]; then
	# there is apt-get here
	release_info=$(cat /etc/*-release 2>/dev/null)
	if [[ $(echo "$release_info" | grep 'Ubuntu') != "" ]]; then
		distro_name="ubuntu"
	else 
        	distro_name="debian"
	fi
	distro_codename=$(cat /etc/*-release 2>/dev/null | grep "DISTRIB_CODENAME" | sed "s/DISTRIB_CODENAME=//")
	sed "s|####path_to_repo####|$path_to_repo|g" $maxdir/maxscale.list.template | sed "s|####distro_name####|$distro_name|g" |sed "s|####distro_codename####|$distro_codename|g" > /etc/apt/sources.list.d/maxscale.list
	wget -qO - $path_to_repo/Maxscale-GPG-KEY.public | apt-key add -
fi
