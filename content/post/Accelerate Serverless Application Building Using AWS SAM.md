---
title: "Accelerate Serverless Application Building Using AWS SAM"
date: 2019-03-26
categories:
- aws sam
tags:
- serverless
- sam
- aws
keywords:
- aws
- sam
autoThumbnailImage: true
thumbnailImagePosition: "top"
thumbnailImage: images/aws_sam_introduction.png
coverImage: images/aws_sam_introduction.png
metaAlignment: center
---
Containers and Serverless are two key modern application development models which enterprises are widely adopting in the age of cloud computing. I almost said it like its black or white, but Containers and Serverless are so intertwined, it's more like 51 shades of grey. The cardinal rule when you go serverless is that you never provision clusters, never pay for idle time, application is auto scalable, and high available by default. While Kubernetes is leading the Container adoption, AWS is pushing the envelope on Serverless computing to whole new level with its plethora of Serverless offerings to address every aspect of computing. There is no easy way to build serverless apps on AWS than using AWS Serverless Application Model (AWS SAM). Recently we were building a .NET Core app in visual studio using labmda, api gateway and s3 without realizing that we were using SAM underneath it. Digging deep into SAM made me realize that its doing whole lot than what it looks on the surface. Every application teams considering to go serverless on AWS might want to give SAM quick spin to understand its rapid application development capabilities. I hope to provide you quick primer on AWS SAM through this post. 

<!--more-->
> Go Build, Go Serverless! 
> - Vijay Mateti


# What is AWS SAM?
AWS SAM stands for Serverless Application Model, which in my opinion is an abstraction framework for rapid development of serverless applications using AWS serverless offerings like Lambda, API Gateway, DynamoDB and bunch of AWS event sourcing services. Event sourcing and event driven architectures are now most preferred patterns in building highly scalable, stateless, fault tolerant and asynchronous applications. Applications adopting event driven and event sourcing patterns can right away explore serverless development and deployment models. One might argue that going serverless on aws is vendor lockin, I have seens others built their projects intelligent enough to deploy them on lambda or any container fabric at the same time. Knative is around block with major push from GKE and Pivotal.

On a side note, GCP also offering whole lot of similar serverless capabilities via AppEngine, Firebase and Cloud functions. That's a topic for another day.

## What I like about of SAM?
- Cloudformation is fun as long as its manageable. SAM simplifies the entire stack creation to few lines of code, while allowing to insert any custom cloudformation resources.
- SAM is offered as template in AWS IDE Toolkits for Eclipe, Visual Studio, IntelliJ, PyCharm or use AWS Cloud9 IDE. AWS gets a gold star here for offering may IDE choices.
- SAM allows Local mode to debug lambda functions and api gateway by running them as local docker containers while allowing event sourcing via JSON. [LocalStack](https://localstack.cloud/) I'm watching you!
- Easy CI & CD integration into Code Build, Code Deploy, Code Pipline or Jenkins
- Canary launches is just one line statement, It can't get any simpler than this!
- Tons of samples to choose from on Github [serverless-application-model](https://github.com/awslabs/serverless-application-model) and [AWS Serverless Application Repository](https://console.aws.amazon.com/serverlessrepo/home?region=us-east-1#/available-applications)
- Deploy the entire application microservices as nested applications for maximum reusability and modularization. 
- With recent Reinvent announcement of bring your own runtime to Lambda, serverless possibilities are limitless
 

# How SAM Works?
SAM uses one of the less know  sections in Cloudformation templates called Transform. SAM CLI is responsible to generate the final cloudformtion templates using SAM Template. SAM templates abstracts all the underlying wiring of various AWS resources by applying best practices. You will be amazed to view all those nested templates SAM cli generates in Cloudformation designer. At the time of writing SAM templates offers declaration of the following five resources, out of which AWS::Serverless::Application is key resource for building most of the serverless applications.

- [AWS::Serverless::Api](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-template.html#serverless-sam-template-api)
- [AWS::Serverless::Application](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-template.html#serverless-sam-template-application)
- [AWS::Serverless::Function](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-template.html#serverless-sam-template-function)
- [AWS::Serverless::LayerVersion](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-template.html#serverless-sam-template-layerversion)
- [AWS::Serverless::SimpleTable](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-template.html#serverless-sam-template-simpletable)

# Use Case that you can solve through serverless

Possibilities are endless but here some of the popular use case that your can consider architecting through serverless patter


- Microservices deployed on Lambda exposed as http endpoint on API Gateway
- API access management using Conginto user pools
- Microservices with standalone DynamoDB backend
- Event driven execution of microservices or lamda functions with all possible event sources on AWS
- Alexa skill development 





