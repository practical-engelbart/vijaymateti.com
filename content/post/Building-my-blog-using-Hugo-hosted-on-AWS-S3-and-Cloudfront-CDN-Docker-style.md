---
title: "Using Hugo and Docker to build a website hosted on AWS S3 and Cloudfront"
date: 2019-01-20
categories:
- hugo
tags:
- docker
- aws
- s3
- codebuild
- github
- dockerhub
- cloudfront
- docker
keywords:
- disqus
- google
- gravatar
autoThumbnailImage: true
thumbnailImagePosition: "top"
thumbnailImage: images/hugo-logo.png
coverImage: images/hugo-logo.png
metaAlignment: center
---
Hugo is one of very cool open source static site generators which is built on Go and is used by popular websites like [Kubernetes](https://kubernetes.io/). You can follow throught the steps mentioned in this post to host your website on AWS S3 and Cloudfront CDN.
<!--more-->

# Little History
I was an avid Tech blogger a decade ago where I used to get hundreds of unique visits everyday and then I suddently stopped. With all my recent work in Cloud computing space I decided to build my personal website in the most developer way possible to share my view on the emerging technologies. 


I was debating if I should host my blog on popular sites like Medium or use <acronym title="Content Management System">CMS</acronym> like Wordpress/Drupal on my personal AWS/GCP accounts. Finally I decided to this fun little experiment to host the site on my own without using any traditional CMS. 

I came across [Hugo](https://gohugo.io/) while I was looking to contribute few modification to [Kubernetes website](https://github.com/kubernetes/website) and It was love at first sight.

## Why is Hugo Awesome?
- World's fastest static site generator, you can build and preview your change in milliseconds
- GitHub style markdown syntax with Hugo's powerful shortcodes
- No additional installation needed if you already have Docker
- Website can be hosted on Firebase or AWS S3 along with Cloudfront CDN without any need for database or web server
- Version control of your code in Git repositories
- Beautiful themes with popular integrations like Google Analytics and Disqus 
- Another reason to learn [Go](https://golang.org/)

# Here is the plan
1. Make sure you have a domain name on on popular registrars like Google Domains/GCP Cloud DNS or AWS Route 53. I got [vijaymateti.com](https://vijaymateti.com) on AWS Route 53


2. Create your own Hugo docker image or you can pull my Hugo docker image [vijaymateti/hugo:latest](https://hub.docker.com/r/vijaymateti/hugo) from Docker Hub which is built nightly on AWS Codebuild using alpine base image. 


{{< codeblock "Dockerfile" "dockerfile" "https://github.com/vijaymateti/vijaymateti.com/blob/master/Dockerfile" "Dockerfile" >}}
FROM alpine:latest

LABEL maintainer="Vijay Mateti <vijaymateti@gmail.com>" 

RUN apk add --no-cache \
    curl \
    git \
    openssh-client \
    rsync \
    build-base \
    libc6-compat

ARG HUGO_VERSION

RUN mkdir -p /usr/local/src && \
    cd /usr/local/src && \
    curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-64bit.tar.gz | tar -xz && \
    #curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-64bit.tar.gz | tar -xz && \
    mv hugo /usr/local/bin/hugo && \
    #curl -L https://bin.equinox.io/c/dhgbqpS8Bvy/minify-stable-linux-amd64.tgz | tar -xz && \
    #mv minify /usr/local/bin && \
    addgroup -Sg 1000 hugo && \
    adduser -Sg hugo -u 1000 -h /src hugo

WORKDIR /src

EXPOSE 1313
{{< /codeblock >}}

Thanks for Kubernetes website for my Dockerfile as it uses the best practice of creating non-root user for running the `hugo` command.

I'm using Hugo extended for my build, you can comment that if you want standard Hugo.