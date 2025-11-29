IMAGE_REPO = ghcr.io/tonyo/uncloud-playgrounds/rootfs

all:
	exit 1

build-%:
	docker build \
		--progress plain \
		-f ./$*/Dockerfile \
		-t $(IMAGE_REPO):$* \
		.
.PHONY: build-%


push-%: build-%
	docker push $(IMAGE_REPO):$*
.PHONY: push-%
