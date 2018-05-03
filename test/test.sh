#!/bin/sh

#set -x

# Setup some color variables
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

for i in */; do
  (
    cd "$i" &&
    test -f "cmd" &&
    ./cmd > test.out &&
    diff -qu test.expected  test.out >/dev/null ;
    if [ $? -ne 0 ]; then
      printf "Test %s:\t\t[${red}Failed${reset}]\n" ${i%%/}
      diff -u test.expected test.out
    else
      printf "Test %s:\t\t[${green}OK${reset}]\n" ${i%%/}
    fi
    )
done
