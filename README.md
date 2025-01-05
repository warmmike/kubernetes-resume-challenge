# Kubernetes Resume Challenge

## I decided to take on the [Kubernetes Resume Challenge](https://cloudresumechallenge.dev/docs/extensions/kubernetes-challenge/) to upgrade my workflow across personal and personal projects.

The Kubernetes Resume Challenge has you imagine an e-commerce website and how you can leverage containers, Kubernetes and modern GitOps.

I decided to integrate my homelab into the process.  I have been playing with **Github Action Runner Controller** that automatically deploys and scales Github Action's Runners in my homelab Kubernetes environment.

The challenge has an e-commerce application source code written in PHP.  I used PHP in a previous job to set up a simple website with some backend automation so I felt comfortable that I would be able to make sense of the code.

In Step 1, the challenge recommends taking the CKAD course to familiarize yourself with Kubernetes.  Since I have been using Kubernetes awhile I decided to skip this step and get into the challenge.

For Step 2, I installed docker on my Kubernetes node and used the ```docker-compose.yml``` to begin containerizing the e-commerce web application.  I would be using Github and code deployment, so I needed to make sure all sensitive data would be called using .env files so I got my **.gitignore ready to go**.

The challenge has you, in Step3, going right to deploying Kubernetes in the Public Cloud.  One of the primary advantages to using containerization and Kubernetes is that I can use the same manifests with little modification to run in the Public Cloud.

I used my homelab Kubernetes and private registry to migrate the docker-compose.yml to Kubernetes deployment yaml files.  I had to create Kubernetes secrets and ```secretKeyRef``` them into the deployment yaml environment.  I used Github Actions docker ```build-push-action``` to push to the private registry kicking off one of the Extra Credits of implementing a basic CI/CD pipeline.  Using this, I was able to perform **itterative testing** as I got an early start on Step 4 (deploy), Step 5 (expose), Step 6 (ConfigMaps) and Step 12 (Secrets).

The challenge has you deploy the e-commerce website to a Public Cloud provider in Step 3.  I created a terraform AWS S3 backend bucket to hold the tfstate file that would be used for the rest of the AWS infrastructure **state tracking**.

I used Github Actions ```on: workflow_displatch: push:``` so the deployment could be manually triggered for a terrform destroy operation.

I combined Step 7 and Step 8 for auto scaling the application.  I made sure to install metrics-server so the horizontal pod autoscaler could properly capture the CPU metrics: ```horizontalpodautoscaler.autoscaling/ecom-web   Deployment/ecom-web   cpu: <unknown>/50%```.  I also installed Prometheus and ```watch```ed the Kubernetes pods scale up and down as I ran ```ab -n 10000 -c 10 "http://website-service"``` on the e-commerce website to generate traffic.

To test Step 8 and Step 9 I had to integrate docker **image version tagging** which is always a bit of a pain.  I finally decided to use Github run number to handle container image version tags for rollout and rollback processes: ```${{ env.DOCKER_IMAGE_NAME }}:${{ github.run_number }}```

One challenge extra credit involves **packaging the application in Helm**.  Helm is an important part of managing the CI/CD of Kubernetes applications.  I struggled with the Helm terraform provider since separate tfstate files are required for managing application state vs infrastructure.  I ultimately settled on a Github Helm action but will **move to ArgoCD for this**.

I originally used a NGINX Ingress Controller with an AWS Network Load Balancer for my E-commerce website ingress.  I switched this over to the **AWS Load Balancer Controller and Application Load Balancer**.  I had to create a Kubernetes Service Account with assigned IAM role and policy attached to allow Kubernetes permissions to create the ALB.  Kubernetes takes time to deploy both the AWS Load Balancer Controller and provision the ALB.  I had to set Helm to wait for 120s timeout so Kubernetes would have the AWS LBC Pods in Ready state: ```aws-load-balancer-controller-7d966bd488-868f7   1/1     Running```.  Helm, now configured to wait and with a timeout ```helm upgrade --install --timeout 120s   --wait``` was able to avoid the error I was getting trying to my E-commerce Website Kubernetes ingress: ```Internal error occurred: failed calling webhook "mservice.elbv2.k8s.aws": failed to call webhook: the server could not find the requested resource```

In the end I really enjoyed this challenge and the goals of the Resume Challenge to **build something real** using tools and processes that I can carry forward in my professional and personal projects.  I also have many more ideas on projects and tools to improve this and other projects going forward.  I may have ArgoCD integrated by the time you read this and I would also like to look at Keda for autoscaling pods outside the basic CPU and Memory offered by Kubernetes HPA.
