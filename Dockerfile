FROM alpine:latest

LABEL maintainer="Vijay Mateti <vijaymateti@gmail.com>" 

RUN apk add --no-cache \
    curl \
    git \
    openssh-client \
    rsync \
    build-base \
    libc6-compat

ENV HUGO_VERSION=$(curl -Is https://github.com/gohugoio/hugo/releases/latest \
    | grep -Fi Location \
    | sed -E 's/.*tag\/v(.*)/\1/g;')
    
RUN echo $HUGO_VERSION

RUN mkdir -p /usr/local/src && \
    cd /usr/local/src && \
    curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-64bit.tar.gz | tar -xz && \
    mv hugo /usr/local/bin/hugo && \
    addgroup -Sg 1000 hugo && \
    adduser -Sg hugo -u 1000 -h /src hugo

WORKDIR /src

EXPOSE 1313
