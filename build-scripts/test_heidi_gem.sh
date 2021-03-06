#!/bin/bash

# Copy latest configs from heidi
cp $heidi$conf $hb
sed -i 's/^# source:/source:/' $hb$conf
sed -i 's/^# destination:/destination:/' $hb$conf
sed -i "s/^# theme:/theme:/" $hb$conf

start_gem_server

# Switch to test configs
sed -i "s/$live_theme/$test_theme/g" $hb$conf
sed -i "1 a source 'http://localhost:9292'" $hb$Gemfile
sed -i "s/$live_theme/$test_theme/g" $hb$Gemfile

# Serve test theme
make_gem $test_theme
gem push $new_gem --host http://localhost:9292
serve_image $test_theme

## Switch back to live configs
sed -i "s/$test_theme/$live_theme/g" $hb$conf
sed -i "/source\ 'http:\/\/localhost:9292'/d" $hb$Gemfile
sed -i "s/$test_theme/$live_theme/g" $hb$Gemfile
