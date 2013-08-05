#!/bin/sh
VERSION=2.3.17

fetch() {
  (
  GN="$1-$2.gem"
  if [ ! -s "${GN}" ]; then
    gem fetch "$1" -v "$2"
  fi
  )
}

for i in actionmailer actionpack activerecord activeresource activesupport rails; do
  fetch "${i}" "${VERSION}"
done
fetch rack 1.1.3
