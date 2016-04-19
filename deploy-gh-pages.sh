#!/bin/bash

# http://www.steveklabnik.com/automatically_update_github_pages_with_travis_example/
if [ "$TRAVIS_BRANCH" != "master" ]
then
  echo "This commit was made against the $TRAVIS_BRANCH and not the master! No deploy!"
  # exit 0
fi

yardoc 'lib/**/*.rb' - README.md LICENSE
cd ./doc/
git config --global user.email "nobody@nobody.org"
git config --global user.name "Travis CI"
git init
git remote add origin "https://{$GITHUB_TOKEN}@$github.com/NullVoxPopuli/meshchat.git"
git checkout --orphan gh-pages
git add .
git commit -m"Generate Documentation"
git push -u origin gh-pages -f
