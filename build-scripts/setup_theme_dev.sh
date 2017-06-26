#!/bin/bash

# Move posts, pages and config from howlinbash repo to heidi dev branch
# each file is ignored with "git update-index --assume-unchanged"

hb="$HOME/src/howlinbash/"
hb_pages="$hb/hb-pages/"
hb_posts="$hb_pages/_posts/"
heidi="$HOME/src/heidi/"
hi_posts="$heidi/_posts/"
conf="_config.yml"

# Pull new posts
cd $hb
git submodule update --recursive --remote

cd $heidi
git checkout dev
rm $hi_posts/*

# Move all the Pages in howlinbash into heidi /
for f in `find $hb_pages -maxdepth 1 -type f -printf '%f\n'`;
  do rm "$heidi$f" && cp $hb_pages$f $heidi;
done

# Move all the Posts in howlinbash into heidi _posts
for f in `find $hb_posts -maxdepth 1 -not -path '*/\.*' -type f -printf '%f\n'`;
  do cp $hb_posts$f $hi_posts;
done

# Move config file and remove hb specific build instructions
rm $heidi$conf
cp $hb$conf $heidi
sed -i '/source:\ hb-pages/d' $heidi$conf
sed -i '/destination:\ web/d' $heidi$conf
sed -i '/theme:\ jekyll-theme-heidi/d' $heidi$conf
