memory_limit = 100m
docker_image = memory
docker_container = memory_container

build:
        docker build -t $(docker_image) .

run:
        @if [ -z "$(memory_limit)" ]; then \
                docker run --rm $(docker_image); \
        else \
                docker run --name $(docker_container) -m $(memory_limit) $(docker_image) || \
                docker inspect -f '{{.State}}' $(docker_container) && docker rm $(docker_container) ; \
        fi
