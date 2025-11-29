### Targets and structure inspired by https://github.com/iximiuz/labs-playgrounds/blob/main/Makefile

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

###

PLAYGROUND_IDS = \
	uncloud-cluster-64523f7c # https://labs.iximiuz.com/playgrounds/uncloud-cluster-64523f7c

save-playgrounds:
	@for id in $(PLAYGROUND_IDS); do \
		labctl playground manifest $$id > manifests/$$id.yaml; \
		echo "Saved playground manifest for: $$id"; \
	done
.PHONY: save-playgrounds
