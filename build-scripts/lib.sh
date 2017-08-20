#!/bin/bash

function get_latest_posts()
{
    cd $hb
    git submodule update --recursive --remote
}

function start_gem_server()
{
    if [ $(docker inspect -f '{{.State.Running}}' geminabox) = "true" ]
    then
        return
    else
        cd $HOME/src/geminabox
        docker build -t geminabox .
        docker run -d --rm --name geminabox -p 9292:9292 geminabox:latest
    fi
}

function build_image()
{
    cd $hb
    local theme=$1
    bundle update --source $theme
    bundle exec jekyll build
    docker build -t $image$2 .
}

function serve_image()
{
    local theme=$1
    docker stop blog
    build_image $theme
    docker run -d --rm --name blog -p 3000:80 $image
}

function make_gem()
{
    cd $heidi
    local gem_name=$1
    gemspec="$gem_name.gemspec"
    old_version=`eval cat $gemspec | grep spec.version | cut -f2 -d'"'`

    printf "The current gem version is $old_version\n"
    printf "Enter the new version: "
    read new_version

    old_gem="$gem_name-$old_version.gem"
    new_gem="$gem_name-$new_version.gem"

    sed -i "/spec\.version/{s!$old_version!$new_version!}" $gemspec
    gem build $gemspec                                                                             
    rm $old_gem
}
