#!/bin/bash

## Search in subdirectories and execute git pull
find . -type d -depth 1 -exec bash -c "cd $PWD/{} && git pull" \;
