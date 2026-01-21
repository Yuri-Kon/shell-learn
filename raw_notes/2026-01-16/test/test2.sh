#!/usr/bin/env bash

foo='Hello, world'

function helloFunc() {
 echo $foo
}
cd ~ || exit
echo "Now you are in $(pwd)"
helloFunc
