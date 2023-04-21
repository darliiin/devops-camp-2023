ARG node_version
# Use an official Node runtime as a parent image
FROM --platform=$BUILDPLATFORM node:${node_version}

RUN  git clone https://github.com/udaltsovra/flatris && \
     cd flatris

WORKDIR /app
COPY . /app

RUN  yarn install && \
     yarn test && \
     NODE_OPTIONS=--openssl-legacy-provider yarn build

ENTRYPOINT ["yarn", "start"]
