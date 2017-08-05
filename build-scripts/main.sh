#!/bin/bash

cwd=$(pwd)
heidi=$HOME/src/heidi/
hb=$HOME/src/howlinbash/
scripts=$hb/build-scripts
hb_pages="$hb/hb-pages/"
hb_posts="$hb_pages/_posts/"
hi_posts="$heidi/_posts/"
test_theme="heidi-test"
live_theme="jekyll-theme-heidi"
conf="_config.yml"
Gemfile="Gemfile"


. $scripts/lib.sh

if [ $# -lt 1 ]
then
        echo "Usage : $0 <argument>"
        exit
fi

case "$1" in

'load')
    echo "Are you sure you want to rewrite the local heidi files? "
    read answer
    if [ $answer = "yes" ];
    then 
        . $scripts/load_heidi_dev_env.sh
    else
        echo "Dev load cancelled"
    fi
    ;;
'serve')
    . $scripts/dev_server.sh 
    init_server $2
    ;;
'test')
    . $scripts/test_heidi_gem.sh
    ;;
'bump')
    . $scripts/publish_heidi_gem.sh
    ;;
'deploy')
    . $scripts/publish_howlinbash.sh
    ;;
*)
    echo "Usage : $0 <argument>"
    ;;
esac

cd $cwd
