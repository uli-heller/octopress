#! /bin/bash
# Do not try to use /bin/sh - rvm depends on bash

GIT_PARENT_DIR="${HOME}/git"
GIT_CHECKOUT_DIR="octopress"
GIT_URL="git@github.com:uli-heller/uli-heller.github.com"
GIT_BRANCH="source-2.1" # or "source"
GIT_OCTOPRESS_URL="git@github.com:imathis/octopress.git"

TMPDIR="/tmp/$(basename $0 .sh).$$~"

cleanUp () {
  rm -rf "${TMPDIR}"
}

trap cleanUp 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15
RC=0
set -e

mkdir "${TMPDIR}"
#sudo apt-get update
sudo apt-get install -y gcc build-essential
sudo apt-get install -y libyaml-dev libz-dev libssl-dev
sudo apt-get install -y curl # wget is part of ubuntu, but rvm uses curl
sudo apt-get install -y git

curl -L https://get.rvm.io \
| bash -s stable --ruby
source ~/.rvm/scripts/rvm
rvm install 1.9.3
rvm use 1.9.3
rvm rubygems latest

ruby --version|grep "1\.9\.3"

if [ ! -d "${GIT_PARENT_DIR}" ]; then
  mkdir -p "${GIT_PARENT_DIR}"
fi
cd "${GIT_PARENT_DIR}"
git clone "${GIT_URL}" "${GIT_CHECKOUT_DIR}"
cd "${GIT_CHECKOUT_DIR}"
git checkout "${GIT_BRANCH}"
gem install bundler
bundle install
# rake install['uli']
git remote add octopress "${GIT_OCTOPRESS_URL}"
git fetch octopress
rm -rf _deploy
git init _deploy
cd _deploy
git remote add -t master -f origin "${GIT_URL}"
git checkout master

cleanUp
exit $RC
