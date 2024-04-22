.ONESHELL:
SHELL := /bin/bash
DIR := $(notdir ${CURDIR})

TEXT		:=
BOXNAME		:=
COLOR 		:= 7

.PHONY: .show-text
.show-text: BOXSCRIPT := ./printBoxScript.sh
.show-text:
	@$(BOXSCRIPT) "${BOXNAME}" "${TEXT}" "${COLOR}"

.PHONY: .ask-confirmation
.ask-confirmation:
	@$(MAKE) -s .show-text TEXT="${TEXT} [y/N]" && read ans && [ $${ans:-N} = y ] || exit 1

.PHONY: .put-info
.put-info: GROUP := 
.put-info: COUNT := 0
.put-info:
	@echo "" >> hosts.ini
	@echo "[${GROUP}]" >> hosts.ini
	@for ((i=1; i<=${COUNT}; i++)) do \
		read -p "${GROUP} $$i IP address: " ip_address;\
		read -p "${GROUP} $$i name: " node_name;\
		if [ "${GROUP}" = "Master" ] && [ $$i -eq 1 ]; then\
			if ($(MAKE) -s .ask-confirmation TEXT="Do you want to externally access your cluster?" BOXNAME="${GROUP}" COLOR="5"); then
				read -p "${GROUP} $$i URL: " master_url;\
				sed -i "s/clusterUrl:/clusterUrl: $${master_url}/" variables.yml;\
			fi;\
			sed -i "s/controlPlaneEndpoint:/controlPlaneEndpoint: $${node_name}/" variables.yml;\
		fi;\
		echo "$$node_name ansible_host=root@$$ip_address" >> hosts.ini;\
		echo "  - '$$ip_address $$node_name'" >> variables.yml;\
		if [ ${COUNT} -gt 1 ] && [ $$i -lt ${COUNT} ]; then echo "--------------------"; fi;\
	done

.PHONY: master
.get-info:
	@$(MAKE) -s .show-text TEXT="How many ${BOXNAME} do you need?" && read count
	@if [ "${BOXNAME}" = "Master" ] && [ $${count} -gt 1 ]; then $(MAKE) -s .ask-confirmation TEXT="This playbook is not yet compatible with the multi-master configuration. Continue ?" BOXNAME="Setup" COLOR="3" || exit; fi
	@$(MAKE) -s .put-info GROUP="${BOXNAME}" COUNT=$${count}

.PHONY: all
all:
	@if ((grep "Master" hosts.ini > /dev/null) && ! ($(MAKE) -s .ask-confirmation TEXT="Configuration detected. Do you want to skip it?" BOXNAME="Setup" COLOR="3")) || ! (grep "Master" hosts.ini > /dev/null); then\
		$(MAKE) -s .get-info BOXNAME=Master COLOR=5 || exit 1;\
		$(MAKE) -s .get-info BOXNAME=Nodes	COLOR=3 || exit 1;\
	fi
	@if ($(MAKE) -s .ask-confirmation TEXT="Please, check the configuration. Continue?" BOXNAME="Setup" COLOR="3"); then\
		if ! ( ansible all -m ping -u root );		then $(MAKE) -s .show-text TEXT="Ping error. Check the root user ssh configuration of your instances!" BOXNAME="Setup" COLOR=1 && exit 1; fi;\
		if ! ( ansible-playbook -u root main.yml);	then $(MAKE) -s .show-text TEXT="Error during playbook execution." BOXNAME="Setup" COLOR=1 && exit 1; fi;\
	fi
	@$(MAKE) -s .show-text TEXT="Kubernetes cluster successfully configured!" BOXNAME="Setup" COLOR=2
