#!/bin/bash

# Setup template

template(){
	become_pass=false
	
	if [ $become_pass == "true" ];then
		ask_pass="-K"
	else
		ask_pass=""
	fi

	ansible-playbook -i inventory ubuntu-setup.yml $ask_pass
}

template
