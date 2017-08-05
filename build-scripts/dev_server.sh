#!/bin/bash

function serve_heidi()
{
    cd $heidi
    bundle exec guard
}

function stop_howlinbash()
{
    cd $hb
    docker stop dev
    docker stop dev-server
}

function serve_howlinbash()
{
    stop_howlinbash
    docker run -d --rm --name dev -v "$(pwd):/src" -w /src ruby:2.3 sh -c 'bundle install --path vendor/bundle && exec jekyll build --watch'
    docker build -t howlinbash/dev .
    docker run -d --rm --name dev-server -p 80:80 -v "$(pwd)/web:/usr/share/nginx/html" howlinbash/dev
}

function init_server()
{
    case "$1" in
        'hb')
            serve_howlinbash
            ;;
        'hi')
            serve_heidi
            ;;
        'no')
            stop_howlinbash
            ;;
        *)
            echo "You must serve heidi or howlinbash"
    esac
}
