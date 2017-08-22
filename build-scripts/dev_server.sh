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

function check_howlinbash_server()
{
    if [ $(docker inspect -f '{{.State.Running}}' dev-server) = "true" ]
    then
        return
    else
        serve_howlinbash
    fi
}

function checkout_post_branch()
{
    cd $bp
    if [ "$(git branch --list ${post_name})" ]
    then
        git checkout $post_name
    else
        git checkout -b $post_name
    fi
}

function push_post()
{
    git add $post_file
    git commit -m "Edited $post_file"
    git checkout drafts
    git merge --no-ff --no-edit $post_name
    git push origin drafts
}

function serve_post()
{
    cd $hb
    git config --file=.gitmodules submodule.hb-pages/_posts.branch drafts
    git submodule update --recursive --remote
    git config --file=.gitmodules submodule.hb-pages/_posts.branch master
}

function preview_post()
{
    cd $bp
    local post_file=`eval ls -t | head -n1`
    local post_name=`eval echo $post_file | sed 's/.\{3\}$//; s/^.\{11\}//'`
    check_howlinbash_server
    checkout_post_branch $post_name
    push_post $post_name $post_file
    serve_post
}

function init_server()
{
    case "$1" in
        'theme')
            serve_heidi
            ;;
        'site')
            serve_howlinbash
            ;;
        'post')
            preview_post
            ;;
        'stop')
            stop_howlinbash
            ;;
        *)
            echo "You must serve heidi or howlinbash"
    esac
}
