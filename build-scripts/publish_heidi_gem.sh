#!/bin/bash

# bump gem version; push gem; commit version bump.

make_gem $live_theme
sed -i "/^version/{s!$old_version!$new_version!}" $conf
gem push $new_gem
git add $gemspec $conf
git commit -m "Bump version to $new_version"
git tag -a v$new_version -m "my version $new_version"
