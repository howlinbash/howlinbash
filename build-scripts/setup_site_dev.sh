#!/bin/bash

hb="$HOME/src/howlinbash"

cd $hb
docker stop blog
git submodule update --recursive --remote
bundle update --source jekyll-theme-heidi
bundle exec jekyll build
docker build -t howlinbash/howlinbash .    
docker run -d --rm --name blog -p 3000:80 howlinbash/howlinbash
