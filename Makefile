### Targets and structure inspired by https://github.com/iximiuz/labs-playgrounds/blob/main/Makefile

IMAGE_REPO = ghcr.io/tonyo/uncloud-playgrounds/rootfs
MANIFESTS_DIR = manifests

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

test-%: build-%
	@test -f $*/test.sh || { echo "Error: $*/test.sh not found"; exit 1; }
	docker run --rm $(IMAGE_REPO):$* bash -c "$$(cat $*/test.sh)"
.PHONY: test-%

### Playgrounds

PLAYGROUND_IDS = \
	uncloud-cluster-64523f7c \
	uncloud-uninitialized-cluster-cacb63ae


PLAYGROUND_DIR = $(MANIFESTS_DIR)/playgrounds

# Save playground manifests locally
pull-playgrounds:
	@mkdir -p $(PLAYGROUND_DIR)
	@for id in $(PLAYGROUND_IDS); do \
		labctl playground manifest $$id > $(PLAYGROUND_DIR)/$$id.yaml; \
		echo ">>> Saved playground manifest for: $$id"; \
	done
.PHONY: pull-playgrounds

push-playgrounds:
	@for id in $(PLAYGROUND_IDS); do \
		echo '---'; \
		labctl playground update $$id -f $(PLAYGROUND_DIR)/$$id.yaml; \
		echo ">>> Pushed playground manifest for: $$id"; \
	done
.PHONY: push-playgrounds

### Tutorials

TUTORIALS_DIR = $(MANIFESTS_DIR)/tutorials
TUTORIALS_IDS = \
	uncloud-create-cluster-ebebf72b

pull-tutorials:
	@mkdir -p $(TUTORIALS_DIR)
	@for tutorial in $(TUTORIALS_IDS); do \
		echo '---'; \
		labctl content pull tutorial -f $$tutorial -d $(TUTORIALS_DIR)/$$tutorial; \
	done
