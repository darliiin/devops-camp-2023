# Use an official Node runtime as a parent image 
FROM --platform=$BUILDPLATFORM node:${node_version}

WORKDIR /app
COPY ../ /app

RUN git clone https://github.com/udaltsovra/flatris app/flatris && \
    yarn install && \
    yarn test && \
    NODE_OPTIONS=--openssl-legacy-provider yarn build

ENTRYPOINT ["yarn", "start"]
