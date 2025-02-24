#!/bin/sh


redirect_uri=$1
replacement_ip=${MY_IP:-10.0.2.2}
modified_redirect_uri=${redirect_uri//127.0.0.1/$replacement_ip}

echo "${modified_redirect_uri}" | pbcopy

echo "Modified redirect url copied to clipboard"