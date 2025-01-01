# Kubernetes Resume Challenge

###I decided to take on the [Kubernetes Resume Challenge](https://cloudresumechallenge.dev/docs/extensions/kubernetes-challenge/) to re-affirm my interest in Kubernetes and integrate my Homelab into the workflow.
- Use docker-compose to quickly iterate the Application testing
- Use local Kubernetes to test Github Runner ARC Action Runner Controller, aka Scalable Self Hosted Github Runners
- Implement modern Terraform code structure layout
- AWS autoscale and network testing

###Here I document my journey in reverse chronological order:

- ##Step 11 & Step 10 Extra Credit
  - Liveness and readiness probes
  - I want to look at Keda.
  - Also want to create Helm chart.

- ##Step 9 & Step 8 Rolling Update and Rollback
  - Using ChatGPT for the Ecom Website CSS updates
  - Github Action docker image version tagging
    - The best approach reads Dockerhub metadata to push back the metadata tags.  I went with using github.run-number, also github.sha
      ```
        tags: ${{ env.DOCKER_IMAGE_NAME }}:${{ github.run_number }}
      ```
      ```
        - name: Update Deployment YAML
          run: |
            DOCKER_IMAGE_TAG=${{ github.run_number }}
            sed -i "s|image: ${DOCKER_IMAGE_NAME}:.*|image: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}|" k8s/app-deployment.yaml
      ```

- ##Step 10 & Step 7 Auto Scale the application
  - Horizontal Pod Autoscaling needs resource requests and Metrics Server install, note: unknown below
    ```
          NAME                                           REFERENCE             TARGETS              MINPODS   MAXPODS   REPLICAS   AGE
      horizontalpodautoscaler.autoscaling/ecom-web   Deployment/ecom-web   cpu: <unknown>/50%   1         6         1          9m47s
    ```
  - Prometheus and Grafana installation and port-forward to prepare for load testing
    ```
      kubectl -n prometheus-stack port-forward deploy/prometheus-stack-grafana 3000
    ```

- ##Step 3 (4,5,6) Set Up Kubernetes on Public Cloud
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

- ##Step 2.5 Set Up Kubernetes
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

- ##Step 2 Containerize E-Commerce Website and Database: I used docker-compose to generate the Dockerfile.
  - I struggled to find instalation repo for mysqli until adding this command to Dockerfile:
  ```
    'RUN docker-php-ext-install mysqli'
  ```
  - I used Github + Actions from the start so used .env files for everything is securely managed from the beginning.

- ##Step 1 Certification: I already have a good Kubernetes foundation.  I plan to take the CKAD course and certification when this challenge is complete.
