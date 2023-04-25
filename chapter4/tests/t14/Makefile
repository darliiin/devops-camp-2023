memory_limit=100m
docker_image = memory

build:
	docker build -t $(docker_image) .

run:
	@if [ -z "$(memory_limit)" ]; then \
		docker run --rm  $(docker_image); \
	else \
		docker run -m $(memory_limit) $(docker_image) || docker inspect -f '{{.State}}' $$(docker ps -lq); \
	fi
