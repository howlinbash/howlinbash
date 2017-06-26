#!/bin/bash

# Build docker image from latest changes and deploy to server

cwd=$(pwd)
hb="$HOME/src/howlinbash"

cd $hb
git submodule update --recursive --remote
bundle update --source jekyll-theme-heidi
bundle exec jekyll build
docker build -t howlinbash/howlinbash .
docker push howlinbash/howlinbash

ssh hb << EOF
cd compose
docker pull howlinbash/howlinbash:latest
docker stop dev || true
docker rm dev || true
docker rmi -f howlinbash/howlinbash:current || true
docker tag howlinbash/howlinbash:latest howlinbash/howlinbash:current
docker-compose up -d
EOF

cd $cwd
