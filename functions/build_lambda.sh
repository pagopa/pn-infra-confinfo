#!/bin/sh

for folder in */ ; do
  ( cd "$folder" && npm run test-build )
done