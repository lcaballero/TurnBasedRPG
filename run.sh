#!/bin/bash

setup() {
    haxelib install lime
    haxelib install openfl
    haxelib install flixel
    haxelib run lime setup
    haxelib install flixel-tools
    haxelib run flixel-tools setup
    haxelib update flixel
    haxelib install flixel-addons
    haxelib update flixel-addons
}

clean() {
    lime clean html5
}

build() {
    lime build html5 && lime run html5 -v
}

"$@"

