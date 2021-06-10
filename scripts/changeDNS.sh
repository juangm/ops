#!/bin/bash
# Need to run with SUDO and pass the new DNS to setup

NEW_DNS=$1

networksetup -setdnsservers Wi-Fi empty
networksetup -setdnsservers Wi-Fi $NEW_DNS
killall -HUP mDNSResponder

# Check available DNS after changes
scutil --dns | grep "nameserver\[[0-9]*\]"
