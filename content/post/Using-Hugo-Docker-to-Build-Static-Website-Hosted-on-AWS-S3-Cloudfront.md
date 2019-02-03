---
title: "Using Hugo and Docker to Build Static Website Hosted on AWS S3 and Cloudfront"
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
Hugo is one the of very cool open source static site generators which is built on Go and is used by popular websites like [Kubernetes](https://kubernetes.io/). You can follow through the steps mentioned in this post to host your website on AWS S3 and Cloudfront CDN.
<!--more-->

<!--toc-->

# Little History
I was an avid Tech blogger a decade ago where I used to get hundreds of unique visits everyday and then I suddenly stopped. With all my recent work in Cloud computing space I decided to build my personal website in the most developer way possible to share my views on the emerging technologies. 


I was debating if I publish my views on popular sites like Medium or use <acronym title="Content Management System">CMS</acronym> like WordPress/Drupal on my personal AWS/GCP accounts. Finally I decided to try fun little experiment to host the site on my own without using any traditional CMS. 

I came across [Hugo](https://gohugo.io/) while I was looking to contribute few modification to [Kubernetes website](https://github.com/kubernetes/website) and it was love at first sight.

## Why is Hugo Awesome?
- Blazing fast static site generator where you can build and preview your changes in milliseconds
- GitHub style markdown syntax with Hugo's powerful shortcodes
- No additional installation needed if you already have Docker
- Website can be hosted on Firebase or AWS S3 along with Cloudfront CDN without any need for database or web server
- Version control of your code in Git repositories
- Beautiful themes with popular integrations like Google Analytics and Disqus 
- Another reason to learn [Go](https://golang.org/)

# Here is the plan
You can follow through below steps on AWS Console by referring the associate guides. I could have attached Terraform or CloudFormation templates but you wouldn't get the feel of building it by hand.

## 1. Prep your domain name
Make sure you have a domain name on on popular registrars like Google Domains/GCP Cloud DNS or AWS Route 53. I got [vijaymateti.com](https://vijaymateti.com) on AWS Route 53 for $12 per year.

Setup your SSL certificate on AWS Certificate Manager which can be associated to both yourdomain.com and www.yourdomain.com. 

## 2. Setup your S3 buckets

Follow through the steps mentioned in this S3 developer guide [Hosting a Static Website on Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html) and also make sure you configure S3 redirect for www.yourdomain.com back to yourdomain.com


## 3. Configure Cloudfront CDN for your S3 buckets

Use AWS Cloudfront CDN to cache your site on global edge locations for faster load times. Follow through this informative video for more instructions [CloudFront to serve a static website hosted on Amazon S3](https://aws.amazon.com/premiumsupport/knowledge-center/cloudfront-serve-static-website/)

S3 static websites with Cloudfront CDN has problem serving prettyURLs which can be resolved by deploying this Lambda@Edge function. You can follow through the instructions here to [Implementing Default Directory Indexes in Amazon S3-backed Amazon CloudFront Origins Using Lambda@Edge](https://aws.amazon.com/blogs/compute/implementing-default-directory-indexes-in-amazon-s3-backed-amazon-cloudfront-origins-using-lambdaedge/)


## 4. Create or Pull latest Hugo Docker image

Create your own Hugo docker image or you can pull my Hugo docker image [vijaymateti/hugo:latest](https://hub.docker.com/r/vijaymateti/hugo) from Docker Hub which is built nightly on AWS CodeBuild using alpine base image. 

I have copied the above Dockerfile from Kubernetes website GitHub repo. It uses alpine base image and applies container best practice of creating non-root user for running the `hugo` command.

I'm using hugo extended version for my build, you can toggle the comment that if you want standard Hugo.


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

Latest hugo version can be found by running the following command :

```shell
curl -Is https://github.com/gohugoio/hugo/releases/latest \
| grep -Fi Location \
| sed -E 's/.*tag\/v(.*)/\1/g;'
```

At the time of writing this post `v0.53` is latest version of Hugo and you can build your docker image by issuing the following command. 

```
docker build --build-arg HUGO_VERSION=0.53 --rm -f "Dockerfile" -t hugo:latest .
```

May be you can wrap them all up in Makefile but I like to run these commands on terminal to feel connected with docker and aws cli once in a while.

## 5. Create your Hugo site 

```shell
mkdir yourdomain.com
cd yourdomain.com
docker run --rm -it -v $PWD:/src -p 1313:1313 -u hugo vijaymateti/hugo:latest hugo new site .
git init
git add .
git commit -m "first commit of my Hugo site"
git remote add origin https://github.com/username/yourrepo.git
```

Make sure you add `.gitignore` and commit to the repo to ignore draft dev and public folders generated by Hugo.

{{< codeblock ".gitignore"  "git" "https://github.com/vijaymateti/vijaymateti.com/blob/master/.gitignore" ".gitignore" >}}
# Ignore dev/ folder
dev/
# Ignore public/ folder
public/
{{< /codeblock >}}

## 6. Customize your Site

You can use your favorite editor to customize your site. I love Visual Studio Code on my Mac to split screen and live-preview the changes in browser every time I save.

You may want to pick one of themes that you like and add them to your repo under themes folder. Follow the instructions mentioned in the themes guide on how to edit the 'config.toml/config.json' to customize various options supported by the theme.

I have used [Tranquilpeak](https://github.com/kakawait/hugo-tranquilpeak-theme) as my site theme. 

You can start by executing the following commands inside your hugo root folder

```shell
cd themes
git clone https://github.com/kakawait/hugo-tranquilpeak-theme.git
```
Follow the [user guide](https://github.com/kakawait/hugo-tranquilpeak-theme/blob/master/docs/user.md) of the theme to understand various customization options.

To preview your draft changes, execute following docker command inside your repo folder and view it your browser url http://localhost:1313/
```shell
docker run --rm -it -v $PWD:/src -p 1313:1313 -u hugo vijaymateti/hugo:latest hugo server -wD -d dev --bind=0.0.0.0
```

When you are ready to publish your site execute following command and it will create `public` folder with static site content.
```shell
docker run --rm -it -v $PWD:/src -p 1313:1313 -u hugo vijaymateti/hugo:latest hugo --minify
```

## 7. Sync your site with S3

Make sure you create AWS IAM user with policies restricted to S3 write.

Here is the command that I execute to sync `public` folder contents to my S3 bucket using custom IAM user `hugo`

```shell
aws s3 sync --acl "public-read" --sse "AES256" public/ s3://vijaymateti.com --delete --profile hugo
```
# Credits
I would like to thank the contributers of [Hugo](https://gohugo.io), [Kubernetes](https://kubernetes.io) and [Alina Mackenzie](https://alimac.io) showing me the recipes to build this blog.

Let me know if you have any suggestion on my post in the comments. Thank you for going through this lengthy post.



