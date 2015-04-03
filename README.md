# Overview

Demo for [Hello World in EC2 Container Service](https://rossfairbanks.com/2015/03/31/hello-world-in-ec2-container-service.html) blog post. The blog post describes how to run the demo on ECS. The [ecs-hello-world](https://registry.hub.docker.com/u/rossf7/ecs-hello-world/) container is on DockerHub for easy deployment to ECS. It uses [Ruby 2.1.5](https://registry.hub.docker.com/_/ruby/) as its Docker Base Image.

# Demo

The demo consists of 2 Rake tasks. The client takes in a message and posts a JSON message to a SQS queue.

```
rake hello:client['hello world!']

Sent: fbe73a51-0684-49de-9195-020c03704c9b

{
  "container": "909fbdc5351e",
  "payload": "hello world!",
  "timestamp": "2015-03-31T09:14:24+02:00"
}
```

The server polls the queue for messages and outputs them to stdout.

```
rake hello:server

Received: fbe73a51-0684-49de-9195-020c03704c9b
Container 909fbdc5351e said 'hello world!' at 31 Mar 2015 09:14:24 +02:00
```

# Running Locally

* Clone the repository
* Create a SQS queue (see blog post)
* Create an IAM user and policy for accessing the queue (see blog post)
* Create a .env file and set the environment variables

```
AWS_ACCESS_KEY_ID=* IAM access key*
AWS_SECRET_ACCESS_KEY=* IAM secret key
AWS_REGION=eu-west-1 # Other supported regions for ECS are us-east-1 or us-west-1
SLEEP_MILLIS=1000
SQS_ENDPOINT=https://sqs.eu-west-1.amazonaws.com/* Your AWS account num*/ecs-hello-world
```
* Launch client and server containers using [Docker Compose](https://docs.docker.com/compose/)

```
$ docker-compose up
```

# License

This code is licensed under the [MIT license](LICENSE)
