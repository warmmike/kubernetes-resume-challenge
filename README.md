# Kubernetes Resume Challenge

Here I will document my journey completing the Kubernetes Resume Challenge (in reverse):
https://cloudresumechallenge.dev/docs/extensions/kubernetes-challenge/

- STEP7 Scale the application
  - Prometheus and Grafana installation and port-forward to prepare for load testing
    ```
      kubectl -n prometheus-stack port-forward deploy/prometheus-stack-grafana 3000
    ```
  - I want to look at Keda.
  - Also want to add Prometheus and Grafana, how to view.
  - Also want to create Helm chart.

- STEP3 (4,5,6) Set Up Kubernetes on Public Cloud
  - 4,5,6 Deploy, Expose and ConfigMap of the application tweaks from Homelab: Service, Ingress Rule, k8s secrets in pipeline
  - bootstrap has terraform to create the backend S3 bucket for tfstate.
    - I researched alot about the backend S3 tfstate chicken and egg problem and solutions.
  - some not helpful messages when trying to create a S3 bucket with duplicate name.
    - I looked at many options to generate unique S3 bucket names :) .
  - I installed an ingress controller and simple ingress rule.
  - Github Actions manual run requires workflow_dispatch and if: github.event_name == 'workflow_dispatch' later on in destroy
    ```
      on:
        workflow_dispatch:
        push:
    ```
  - Needed to wait for ingress controller
    ```
      kubectl -n ingress-nginx wait --for=jsonpath='{.status.loadBalancer.ingress}' service/ingress-nginx-controller --timeout=60s
    ```

- STEP2.5 Set Up Kubernetes
  - I have been using Github Actions and Self-Hosted Runners for my Homelab
  - Using my Homelab Kubernetes environment gave me the confidence to Deploy and Expose the application, partially completing STEP4, STEP5 and STEP6.
  - Added the following to continuously test container image with imagePullPolicy='Always'
    ```
      kubectl rollout restart deployment/ecom-web
    ```
  - Performance testing
    ```
      ab -n 10000 -c 10 "http://website-service"
      
      kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://website-service/; done"
    ```
  - Transitioning from docker-compose to Kubernetes ConfigMaps and Environment Variables made this process smooth.

- STEP2 Containerize E-Commerce Website and Database: I used docker-compose to generate the Dockerfile.
  - I struggled to find instalation repo for mysqli until adding this command to Dockerfile:
  ```
    'RUN docker-php-ext-install mysqli'
  ```
  - I used Github + Actions from the start so used .env files for everything is securely managed from the beginning.

- STEP1 Certification: I already have a good Kubernetes foundation.  I plan to take the CKAD course and certification when this challenge is complete.
