#!/bin/sh

head CHANGELOG.md

echo "is changelog ok?"
read

echo "updating template projects to latest version with steroids-js"

sh update-steroidsjs-templates.sh

echo "ok?"
read

git add templates
git commit -m "updated templates to use latest steroids-js"

git st

echo "ok?"

read

echo "versioning the npm, now it's a good time to control+c if you don't want to patch ?"

read

DEFAULTSEVERITY=patch
SEVERITY=${1:-$DEFAULTSEVERITY}

npm version $SEVERITY && git push && git push --tags && npm publish ./
