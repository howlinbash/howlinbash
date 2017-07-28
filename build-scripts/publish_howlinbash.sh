#!/bin/bash

# Build docker image from latest changes and deploy to server

get_latest_posts
build_image $live_theme
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
