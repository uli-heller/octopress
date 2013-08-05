#!/bin/bash

CRX_URL='https://clients2.google.com/service/update2/crx?response=redirect&x=id%%3D%s%%26uc'

BN="$(basename "$0")"
D="$(dirname "$0")"
D="$(cd "${D}"; pwd)"

TMPDIR="/tmp/${BN}.$$~"

cleanUp () {
  rm -rf "${TMPDIR}"
}

trap cleanUp 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15

#------------------------------------------------------------------------
#!/usr/bin/env bash
# https://github.com/dominictarr/JSON.sh/blob/master/JSON.sh
# https://github.com/dominictarr/JSON.sh/blob/master/LICENSE.APACHE2
#
# Apache License, Version 2.0
# 
# Copyright (c) 2011 Dominic Tarr
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

throw () {
  echo "$*" >&2
  exit 1
}

BRIEF=0

tokenize () {
  local ESCAPE='(\\[^u[:cntrl:]]|\\u[0-9a-fA-F]{4})'
  local CHAR='[^[:cntrl:]"\\]'
  local STRING="\"$CHAR*($ESCAPE$CHAR*)*\""
  local NUMBER='-?(0|[1-9][0-9]*)([.][0-9]*)?([eE][+-]?[0-9]*)?'
  local KEYWORD='null|false|true'
  local SPACE='[[:space:]]+'
  egrep -ao "$STRING|$NUMBER|$KEYWORD|$SPACE|." --color=never |
    egrep -v "^$SPACE$"  # eat whitespace
}

parse_array () {
  local index=0
  local ary=''
  read -r token
  case "$token" in
    ']') ;;
    *)
      while :
      do
        parse_value "$1" "$index"
        let index=$index+1
        ary="$ary""$value" 
        read -r token
        case "$token" in
          ']') break ;;
          ',') ary="$ary," ;;
          *) throw "EXPECTED , or ] GOT ${token:-EOF}" ;;
        esac
        read -r token
      done
      ;;
  esac
  [[ $BRIEF -ne 1 ]] && value=`printf '[%s]' "$ary"`
}

parse_object () {
  local key
  local obj=''
  read -r token
  case "$token" in
    '}') ;;
    *)
      while :
      do
        case "$token" in
          '"'*'"') key=$token ;;
          *) throw "EXPECTED string GOT ${token:-EOF}" ;;
        esac
        read -r token
        case "$token" in
          ':') ;;
          *) throw "EXPECTED : GOT ${token:-EOF}" ;;
        esac
        read -r token
        parse_value "$1" "$key"
        obj="$obj$key:$value"        
        read -r token
        case "$token" in
          '}') break ;;
          ',') obj="$obj," ;;
          *) throw "EXPECTED , or } GOT ${token:-EOF}" ;;
        esac
        read -r token
      done
    ;;
  esac
  [[ $BRIEF -ne 1 ]] && value=`printf '{%s}' "$obj"`
}

parse_value () {
  local jpath="${1:+$1,}$2"
  case "$token" in
    '{') parse_object "$jpath" ;;
    '[') parse_array  "$jpath" ;;
    # At this point, the only valid single-character tokens are digits.
    ''|[^0-9]) throw "EXPECTED value GOT ${token:-EOF}" ;;
    *) value=$token ;;
  esac
  [[ ! ($BRIEF -eq 1 && ( -z $jpath || $value == '""' ) ) ]] \
      && printf "[%s]\t%s\n" "$jpath" "$value"
}

parse () {
  read -r token
  parse_value
  read -r token
  case "$token" in
    '') ;;
    *) throw "EXPECTED EOF GOT $token" ;;
  esac
}

[[ -n $1 && $1 == "-b" ]] && BRIEF=1

#if [ $0 = $BASH_SOURCE ];
#then
#  tokenize | parse
#fi

JSON.sh () {
  tokenize|parse
}
#------------------------------------------------------------------------


getJson () {
  if [ -z "$2" ]; then
    cat
  else
    cat "$2"
  fi                 \
  |"JSON.sh"         \
  |grep "\[\"$1\"\]" \
  |sed -e "s/^\s*\[\"$1\"\]\s*//" -e "s/^\"//" -e "s/\"$//"
}

trxName () {
  #"name": "__MSG_ext_name__",
  msg="$(expr "$1" : "__MSG_\(.*\)__")"
  if [ ! -z "${msg}" ]; then
    getJson "${msg}" "$2"|getJson "message"
  else
    echo "$1"
  fi
}

mkdir "${TMPDIR}"
(
  cd "${TMPDIR}"
  wget -c "$(printf "${CRX_URL}" "$1")"
  DOWNLOAD_NAME="$(echo *)"
  unzip -qqq -d x "${DOWNLOAD_NAME}"
  VERSION="$(getJson version x/manifest.json)"
  TMP_NAME="$(getJson name x/manifest.json)"
  NAME="$(trxName "${TMP_NAME}" "x/_locales/en/messages.json")"
  rm -rf x
  CRX_NAME="$(echo "${NAME}-${VERSION}"|tr " " "_").crx"
  mv "${DOWNLOAD_NAME}" "${CRX_NAME}"
  echo "${CRX_NAME}"
)

mv "${TMPDIR}/"*.crx .
cleanUp
exit 0
