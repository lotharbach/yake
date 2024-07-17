#!/usr/bin/env bash

set -eu

source ../tools/install.sh

install_yq

version="${version:-$($YQ '.spec.chart.spec.version' ../../gardener-operator/gardener-operator.yaml | head -1)}"

tag="v${version}"
repo="ghcr.io/yakecloud"
provider_local_image="${repo}/gardener-extension-provider-local:${tag}"
mcm_local_image="${repo}/machine-controller-manager-provider-local:${tag}"

# if docker manifest inspect "${provider_local_image}" 1>/dev/null 2>&1; then
#   echo "remote image ${provider_local_image} already exists. skipping build."
#   exit 0
# fi

# if docker manifest inspect "${mcm_local_image}" 1>/dev/null 2>&1; then
#   echo "remote image ${mcm_local_image} already exists. skipping build."
#   exit 0
# fi

test -d gardener-upstream || git clone --depth 1 --branch "${tag}" https://github.com/gardener/gardener gardener-upstream

cd gardener-upstream || exit 1

docker build --build-arg EFFECTIVE_VERSION="${tag}" -t "${provider_local_image}" -f ../Dockerfile --target gardener-extension-provider-local .
docker build --build-arg EFFECTIVE_VERSION="${tag}" -t "${mcm_local_image}" -f ../Dockerfile --target machine-controller-manager-provider-local .

#docker push "${provider_local_image}"
#docker push "${mcm_local_image}"
