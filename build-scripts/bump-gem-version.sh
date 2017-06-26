#!/bin/bash

# bump gem version; push gem; commit version bump.

heidi="$HOME/src/heidi/"
gemspec="jekyll-theme-heidi.gemspec"
old_version=`eval cat $gemspec | grep spec.version | cut -f2 -d'"'`
old_version_regex=`echo $old_version | sed 's/\./\\\\./g'`

cd $heidi

printf "WARNING: This commit will not be pushed to github\n"
printf "The current gem version is $old_version\n"
printf "Enter the new version: "
read new_version

new_version_regex=`echo $new_version | sed 's/\./\\\\./g'`
old_gem="jekyll-theme-heidi-$old_version.gem"
new_gem="jekyll-theme-heidi-$new_version.gem"

sed -i "s/version\ =\ \"$old_version_regex\"/version\ =\ \"$new_version_regex\"/g" $gemspec
gem build $gemspec                                                                             
rm $old_gem
gem push $new_gem
git add $gemspec
git commit -m "Bump version to $new_version"
git tag -a v$new_version -m "my version $new_version"
# git push origin --tags
