#!/bin/sh
curl --no-progress-meter $3 --data-binary @"$1/post" -o "$1/result"  -X POST -H "Content-Type: application/octet-stream"  -b "$1/cookie" -c "$1/cookie" https://$2 2>$1/stderr
