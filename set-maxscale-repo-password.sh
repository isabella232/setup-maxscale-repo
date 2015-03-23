#!/bin/bash
echo "Please enter username: "
read username
echo "Please enter password: "
read password

path_to_repo="http://$username:$password@jenkins.engskysql.com/repository/develop/mariadb-maxscale/1.0/"


 /usr/local/mariadb-maxscale/repo-setup/setup-maxscale-repos.sh $path_to_repo
