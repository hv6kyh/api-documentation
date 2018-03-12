#!/bin/bash

set -e

# We add a fake HOME so that bundle does not try to install in /
export HOME=/dmake

pushd $(dirname $0)

bundle install


if [ "$#" -gt 0 ]; then
    versions="$@"
else
    versions=$(ls "versions")
fi;

for version in $versions; do

    echo "Building docs $version"

    ## bundle exec middleman need a source folder so we create a temp symlink
    rm -rf current_version
    ln -s "versions/$version" current_version

    bundle exec middleman build

    # Modify index to use Django static files
    sed -i '1s/^/{% load staticfiles %}\n/' build/index.html
    sed -i 's/"|\([^|]*\)|"/{{\1}}/g' build/index.html
    sed -i "s|href=\"stylesheets/\(.*\).css\"|href=\"{% static \"docs/$version/stylesheets/\1.css\" %}\"|" build/index.html
    sed -i "s|src=\"javascripts/\(.*\).js\"|src=\"{% static \"docs/$version/javascripts/\1.js\" %}\"|" build/index.html
    sed -i "s|src=\"images/\(.*\).png\"|src=\"{% static \"docs/$version/images/\1.png\" %}\"|" build/index.html

    # Move to correct location
    template_dir="../developers/docs/templates/docs/$version"
    static_dir="../developers/docs/static/docs/$version/"

    rm -rf "$template_dir"
    mkdir -p $template_dir
    mv build/index.html "$template_dir/"

    rm -rf "$static_dir"
    mkdir -p $static_dir
    mv build/* "$static_dir/"

done

popd
