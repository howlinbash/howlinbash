#!/bin/bash

heidi=$HOME/src/heidi
scripts=$HOME/src/howlinbash/build-scripts

cd $HOME

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
        . $scripts/setup_theme_dev.sh
    else
        echo "Dev load cancelled"
    fi
    ;;
'serve')
    cd $heidi
    bundle exec guard
    ;;
'test')
    . $scripts/setup_site_dev.sh
    ;;
'bump')
    . $scripts/bump-gem-version.sh
    ;;
'deploy')
    . $scripts/deploy_howlinbash.sh
    ;;
*)
    echo "Usage : $0 <argument>"
    ;;
esac
