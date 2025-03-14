#!/usr/bin/env bash
# build the docker image

kubectl config use-context garden-testpro--tushar-external
kubectl cluster-info

echo "================================================================================================="
echo "This script is only used during development to quickly deploy updates to a our cluster. "
echo "It is not called by the Jenkins. You should also not use it to patch or update a live cluster."
echo "================================================================================================="
echo ""

VERSION=$(uuidgen)
PROJECT=tushar-repository
REPOSITORY=docker.io/tushar1309

# causes the shell to exit if any subcommand or pipeline returns a non-zero status.
set -e


# build the new docker image
#
echo '>>> Building new image'
docker build --rm --no-cache=true --rm -t $REPOSITORY/$PROJECT:$VERSION . --platform="linux/amd64"

echo '>>> Push new image'
docker push $REPOSITORY/$PROJECT:$VERSION

# Apply the YAML passed into stdin and replace the version string first
cat ./yaml/deployment.yaml | sed "s~<image-name>~$REPOSITORY/$PROJECT:$VERSION~g" | kubectl apply -f -
kubectl apply -f ./yaml/ingress.yaml
