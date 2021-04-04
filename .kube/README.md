# &#x2638; Kubernetes

- @todo php environment vars

This is provided as a starter/example setup. You can run kubernetes locally with an orchestration tool such as
[minikube](https://minikube.sigs.k8s.io/docs/) and [kubectl](https://kubernetes.io/docs/tasks/tools/).

```console
minikube start
```

Apply secrets and config maps:

```console
kubectl apply -f .kube/mysql-secret.yaml
kubectl apply -f .kube/php-fpm-secret.yaml
kubectl create configmap nginx-conf --from-file=.docker/nginx/default.conf
kubectl create configmap php-ini --from-file=.docker/php/production/php.ini
```

Apply deployments and services:

```console
kubectl apply -f .
```

Start service:

```console
minikube service nginx-service
```

## Using local image

You may find it helpful to work with a local image instead of continually deploying to a container registry.

```console
eval (minikube docker-env)
docker run -d -p 5005:5005 --restart=always --name registry registry:2
docker build . -f .docker/Dockerfile -t localhost:5005/cakephp-docker:4.2-latest
```

In [php.yaml](php.yaml) change the image to `localhost:5005/cakephp-docker:4.2-latest`.

> Source: https://shashanksrivastava.medium.com/how-to-set-up-minikube-to-use-your-local-docker-registry-10a5b564883
