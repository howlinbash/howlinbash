#!/bin/bash

function deploy_to_staging()
{
    get_latest_posts
    build_image $live_theme ":next"
    docker push $image:next
    ssh hb << EOF
        cd compose
        docker pull $image:next
        docker tag $image:next $image:staging
        docker-compose up -d
EOF
}

function deploy_to_live()
{
    docker pull $image:current
    push_image_as current previous
    push_image_as next current
    ssh hb << EOF
        cd compose
        docker pull $image:previous
        docker tag $image:staging $image:live
        docker tag $image:previous $image:staging
        docker-compose up -d
EOF
}

function revert_live()
{
    ssh hb << EOF
        cd compose
        docker tag $image:staging $image:live
        docker pull $image:current
        docker tag $image:current $image:staging
        docker-compose up -d
EOF
    docker pull $image:previous
    push_image_as previous current
}

function deploy()
{
    case "$1" in
        'stage')
            deploy_to_staging
            ;;
        'live')
            deploy_to_live
            ;;
        'revert')
            revert_live
            ;;
        *)
            echo "You must deploy something"
    esac
}
