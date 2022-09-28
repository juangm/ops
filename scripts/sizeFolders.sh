#!/bin/bash

## Search in subdirectories and get their size
find . -type d -depth 1 | xargs du -hs;
