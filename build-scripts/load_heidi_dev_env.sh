#!/bin/bash

# Move posts, pages and config from site repo and start local dev server
# each file is ignored with "git update-index --assume-unchanged"

get_latest_posts
cd $heidi
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
sed -i 's/^source:/# source:/' $heidi$conf
sed -i 's/^destination:/# destination:/' $heidi$conf
sed -i "s/^theme:/# theme:/" $heidi$conf
