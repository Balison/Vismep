#!/bin/bash

# We want to see what is executed and fail on bad exit codes
set -ex

# download image and vm
curl https://get.pharo.org/70+vm | bash

./pharo Pharo.image metacello install "filetree://" BaselineOfPyMemory --install=development
./pharo Pharo.image eval --save '(IceRepositoryCreator new repository: nil; location: FileSystem workingDirectory; createRepository) register'

if [[ $* == *--dev* ]]
then echo "Ready for development"; exit 0
else echo "Deploying AlProfiler"
fi

./pharo Pharo.image eval --save "PyDeployScript deploy"
echo "Ready. Open AlProfiler with start.sh script."
