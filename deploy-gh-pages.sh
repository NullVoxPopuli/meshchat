# http://www.steveklabnik.com/automatically_update_github_pages_with_travis_example/
if [ "$TRAVIS_BRANCH" != "master" ]
then
  echo "This commit was made against the $TRAVIS_BRANCH and not the master! No deploy!"
  # exit 0
fi

cd ./doc/
git checkout --orphan gh-pages
git add .
git commit -m"Generate Documentation"
git push -u origin gh-pages -f
