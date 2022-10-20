#!/bin/bash

# Setup template

template(){
	become_pass=true
	
	if [ $become_pass == "true" ];then
		ask_pass="-K"
	else
		ask_pass=""
	fi
	cd roles && git pull
	cd ../

	ansible-playbook -i inventory ubuntu-setup.yml $ask_pass
}

template
