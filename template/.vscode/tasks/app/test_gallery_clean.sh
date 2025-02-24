#!/bin/sh

rm -rf test/gallery
find . -type d -name 'failures' -exec rm -rf {} +
find . -type d -name 'screenshots' -exec rm -rf {} +