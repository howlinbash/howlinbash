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
    cd $hb
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

function make_gem()
{
    cd $heidi
    local gem_name=$1
    gemspec="$gem_name.gemspec"
    local old_version=`eval cat $gemspec | grep spec.version | cut -f2 -d'"'`
    local old_version_regex=`echo $old_version | sed 's/\./\\\\./g'`

    printf "The current gem version is $old_version\n"
    printf "Enter the new version: "
    read new_version

    local new_version_regex=`echo $new_version | sed 's/\./\\\\./g'`
    old_gem="$gem_name-$old_version.gem"
    new_gem="$gem_name-$new_version.gem"

    sed -i "s/version\ =\ \"$old_version_regex\"/version\ =\ \"$new_version_regex\"/g" $gemspec
    gem build $gemspec                                                                             
    rm $old_gem
}
