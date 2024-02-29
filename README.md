# docker-nginx

This repository provides Rocky Linux-based nginx images.

## Build

Create a builder:

```bash
docker buildx create --use --name builder
```

Build for `linux/amd64` and export images to the default image store (`docker images`):

```bash
docker buildx bake --load
```

Build for a different or multiple architectures:

```bash
docker buildx bake --load --set="*.platform=linux/amd64,linux/arm64"
```

Note that building images for multiple architectures requires one of the following:

* [Containerd image store](https://docs.docker.com/storage/containerd/) for the `--load` flag to work
* Pushing directly to a registry, e.g. `docker buildx bake --push --set="*.platform=linux/amd64,linux/arm64"`
* Using other [output types](https://docs.docker.com/reference/cli/docker/buildx/build/#output) or omitting output flags to keep build cache only

## Use

To build a react based client side rendered single page application, use the following Dockerfile.

```Dockerfile
FROM acornsaustralia/node:20 as dev

ARG UID=1000

RUN useradd -d /app -l -m -Uu ${UID} -r -s /bin/bash node && \
  chown -R node:node /app

USER node
ENV LANG C.UTF-8

WORKDIR /app
COPY --chown=node:node package.json package-lock.json /app/
RUN npm install -q

# Copy application
COPY --chown=node:node . /app/

RUN npm run build


FROM acornsaustralia/nginx:latest as prod

COPY --from=dev --chown=nginx:nginx /app/build/ /usr/share/nginx/html
```