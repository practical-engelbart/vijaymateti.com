FROM alpine:latest
  
LABEL maintainer="Vijay Mateti <vijaymateti@gmail.com>"

RUN apk add --no-cache \
    curl \
    git \
    openssh-client \
    rsync \
    build-base \
    libc6-compat

RUN HUGO=$(curl -Is https://github.com/gohugoio/hugo/releases/latest     | grep -Fi Location     | sed -E 's/.*tag\/v(.*)/\1/g;' |xargs ) && \
    export HUGO && \
    mkdir -p /usr/local/src && \
    cd /usr/local/src && \
    curl -L "https://github.com/gohugoio/hugo/releases/download/v${HUGO}/hugo_extended_${HUGO}_linux-64bit.tar.gz" | tar -xz && \
    mv hugo /usr/local/bin/hugo && \
    addgroup -Sg 1000 hugo && \
    adduser -Sg hugo -u 1000 -h /src hugo

WORKDIR /src

EXPOSE 1313
