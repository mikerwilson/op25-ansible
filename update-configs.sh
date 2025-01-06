#!/usr/bin/env bash
ansible-playbook -t configs -i hosts.local.yml site.yml
