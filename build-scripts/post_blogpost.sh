#!/bin/bash

function post_post()
{
    docker pull $image:current
    push_image_as current previous
    push_image_as next current
    ssh hb << EOF
        cd compose
        docker pull $image:previous
        docker pull $image:current
        docker tag $image:previous $image:staging
        docker tag $image:current $image:live
        docker-compose up -d
EOF
}

# Pick blogpost to post
cd $bp
git checkout drafts
printf "Which file do you wish to post?\n"
read -e post_file
post_name=`eval echo $post_file | sed 's/.\{3\}$//; s/^.\{11\}//'`

# Push blogpost
git checkout master
git checkout drafts -- $post_file
git commit -m "Post $post_file"
git push origin master

# Delete old blogpost draft
git checkout drafts
git rm $post_file 
git commit -m "Remove draft $post_name"
git merge --no-ff --no-edit master
git branch -d $post_name

build_image $live_theme ":next"
post_post
