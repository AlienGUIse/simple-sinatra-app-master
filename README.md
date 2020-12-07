# simple-sinatra-app-master
This repo is a basic CI/CD automation pipeline which contains my solution to deploy this sinatra site on AWS ECS
The ip address to test the site is 3.25.139.83

Pre-requests:

1. GitHub or any source code managemnt tools
2. Buildkite
3. AWS ECR and ECS

Firstly need to create two pipelines in Buildkite, then create an EC2 instance as buildkite agent.
To config buildkite agent, need to install docker, awscli, buildkite-agent(register it with token), jq, terraform.
The package_ecr.sh will build docker image and push it to ECR which is created by terraform, then buildkite will load 
another pipeline using pipeline-ecs.yml file to deploy it on ECS with all service and task created by terraform in this repo.

Restrictions: 
1. Hostport cannot be different with docker port which is 80 due to vpc type is awsvpc
2. Should deploy https instead of http
              
