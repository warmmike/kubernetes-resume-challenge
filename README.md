# Kubernetes Resume Challenge

Here I will document my journey completing the Kubernetes Resume Challenge (in reverse):
https://cloudresumechallenge.dev/docs/extensions/kubernetes-challenge/

- STEP3 Set Up Kubernetes on Public Cloud
  - Github Actions and Terraform will be used for this STEP.

- STEP2.5 Set Up Kubernetes on Public Cloud
  - I have been using Actions and Self-Hosted Runners for my Homelab
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
