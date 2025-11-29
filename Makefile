

build-%:
	docker build \
		--progress plain \
		-f ./$*/Dockerfile \
		-t $* \
		.
.PHONY: build-%
