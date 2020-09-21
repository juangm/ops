#!/bin/bash

## Search in subdirectories and execute git pull
find . -type d -depth 1 -exec bash -c "echo 'Git Pull in -> {}' && cd $PWD/{} && git pull" \;
