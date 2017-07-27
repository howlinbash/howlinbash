#!/bin/bash

function serve_and_watch()
{
    cd $heidi
    bundle exec guard
}

function get_latest_posts()
{
    cd $hb
    git submodule update --recursive --remote
}

function build_image()
{
    local theme=$1
    bundle update --source $theme
    bundle exec jekyll build
    docker build -t howlinbash/howlinbash .
}

function serve_image()
{
    local theme=$1
    docker stop blog
    build_image $theme
    docker run -d --rm --name blog -p 3000:80 howlinbash/howlinbash
}
