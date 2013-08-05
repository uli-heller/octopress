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

if [ $0 = $BASH_SOURCE ];
then
  tokenize | parse
fi
