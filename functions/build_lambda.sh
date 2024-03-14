#!/bin/sh

for folder in */ ; do
  cd "$folder"

  # Executes the test and build
  npm run test-build

  # Calculates the SHA-256 of tracked git files and takes the full hash
  sha=$(git ls-files | xargs shasum -a 256 | shasum -a 256 | cut -d ' ' -f 1)

  # Renames function.zip with the calculated SHA-256
  if [ -f "function.zip" ]; then
      mv function.zip "function_$sha.zip"
      
      # Creates a .current_build file with the name of the zip file
      printf "function_$sha.zip" > .current_build
  else
      echo "function.zip not found in $folder"
  fi

  cd ..
done