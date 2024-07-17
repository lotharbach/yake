# builder
FROM golang:1.22.5 AS builder
ARG GOPROXY=https://proxy.golang.org,direct
ENV GOPROXY=$GOPROXY
WORKDIR /go/src/github.com/gardener/gardener
COPY . .
ARG EFFECTIVE_VERSION
RUN EFFECTIVE_VERSION=$EFFECTIVE_VERSION ./hack/install.sh ./cmd/gardener-extension-provider-local
RUN EFFECTIVE_VERSION=$EFFECTIVE_VERSION ./hack/install.sh ./cmd/machine-controller-manager-provider-local


# distroless-static
FROM gcr.io/distroless/static-debian12:nonroot as distroless-static

# gardener-extension-provider-local
FROM distroless-static AS gardener-extension-provider-local
COPY --from=builder /go/bin/gardener-extension-provider-local /gardener-extension-provider-local
WORKDIR /
ENTRYPOINT ["/gardener-extension-provider-local"]

# machine-controller-manager-provider-local
FROM distroless-static AS machine-controller-manager-provider-local
COPY --from=builder /go/bin/machine-controller-manager-provider-local /machine-controller-manager-provider-local
WORKDIR /
ENTRYPOINT ["/machine-controller-manager-provider-local"]
