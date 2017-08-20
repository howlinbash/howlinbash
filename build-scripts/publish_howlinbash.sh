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
    docker tag $image:current $image:previous
    docker push $image:previous
    docker tag $image:next $image:current
    docker push $image:current
    ssh hb << EOF
        docker pull $image:previous
        docker tag $image:staging $image:live
        docker tag $image:previous $image:staging
        docker-compose up -d
EOF
}

function revert_to_live()
{
    ssh hb << EOF
        docker tag $image:staging $image:live
        docker pull $image:current
        docker tag $image:current $image:staging
        docker-compose up -d
EOF
    docker pull $image:previous
    docker tag $image:previous $image:current
    docker push $image:current
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
