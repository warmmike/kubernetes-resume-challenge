# Kubernetes Resume Challenge

Here I will document my journey completing the Kubernetes Resume Challenge

My plan of attack will be the following:
- Test via docker compose
  - needed instead of apt
  ```
    'RUN docker-php-ext-install mysqli'
  ```
  - env files for both frontend and db

- Deploy to my homelab kubernetes using self-hosted arc runners
  - Had to convert environment variables to k8s form
  - Worked on Dark Mode since it will be the same in the Cloud
  - Had ChatGPT help with DarkMode css
  - Included the following to rollout + imagePullPolicy='Always'
  ```
    kubectl rollout restart deployment/ecom-web
  ```
  - Performance testing
  ```
    ab -n 10000 -c 10 "http://xxx.xxx.xxx.xxx:xxxxx/"
  ```
- Migrate to public repos and cloud
  - migrate to public repo
  - terraform eks
  - 
