#!/bin/bash
tmux new-session -d -s aptupdatemendem "sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && exit"
