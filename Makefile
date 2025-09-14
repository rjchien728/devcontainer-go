IMAGE_NAME = devcontainer-go
DOCKERFILE = Dockerfile

# --- Version arguments per Go version ---
BUILD_ARGS_1_18 = \
	--build-arg GO_VERSION=1.18 \
	--build-arg PROTOC_GEN_GO_VERSION=v1.28.1 \
	--build-arg PROTOC_GEN_GO_GRPC_VERSION=v1.2.0 \
	--build-arg GOPLS_VERSION=v0.14.2 \
	--build-arg MOCKERY_VERSION=v2.20.0 \
	--build-arg GOVULNCHECK_VERSION=v1.0.1

BUILD_ARGS_1_21 = \
	--build-arg GO_VERSION=1.21 \
	--build-arg PROTOC_GEN_GO_VERSION=v1.31.0 \
	--build-arg PROTOC_GEN_GO_GRPC_VERSION=v1.3.0 \
	--build-arg GOPLS_VERSION=v0.20.0 \
	--build-arg MOCKERY_VERSION=v2.32.4 \
	--build-arg GOVULNCHECK_VERSION=v1.0.1

BUILD_ARGS_1_23 = \
	--build-arg GO_VERSION=1.23 \
	--build-arg PROTOC_GEN_GO_VERSION=v1.36.0 \
	--build-arg PROTOC_GEN_GO_GRPC_VERSION=v1.5.1 \
	--build-arg GOPLS_VERSION=v0.20.0 \
	--build-arg MOCKERY_VERSION=v2.47.0 \
	--build-arg GOVULNCHECK_VERSION=v1.1.4

BUILD_ARGS_1_24 = \
	--build-arg GO_VERSION=1.24 \
	--build-arg PROTOC_GEN_GO_VERSION=v1.36.9 \
	--build-arg PROTOC_GEN_GO_GRPC_VERSION=v1.5.1 \
	--build-arg GOPLS_VERSION=v0.20.0 \
	--build-arg MOCKERY_VERSION=v2.50.0 \
	--build-arg GOVULNCHECK_VERSION=v1.1.4

# --- Build function ---
define build_template
	docker buildx build \
		--load \
		-f $(DOCKERFILE) \
		$($(1)) \
		-t $(IMAGE_NAME):$(2) \
		.
endef

.PHONY: all 1.18 1.21 1.23 1.24

all: 1.18 1.21 1.23 1.24

1.18:
	$(call build_template,BUILD_ARGS_1_18,1.18)

1.21:
	$(call build_template,BUILD_ARGS_1_21,1.21)

1.23:
	$(call build_template,BUILD_ARGS_1_23,1.23)

1.24:
	$(call build_template,BUILD_ARGS_1_24,1.24)