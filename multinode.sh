#!/bin/bash

# Setup template

become_pass=true
	
if [ $become_pass == "true" ];then
	ask_pass="-K"
else
	ask_pass=""
fi

cd roles && git pull
cd ../

ansible-playbook -i inventory osh-setup.yml $ask_pass
