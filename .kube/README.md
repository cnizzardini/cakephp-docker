# &#x2638; Kubernetes

This is provided as a starter/example setup. You can run kubernetes locally with an orchestration tool such as
[minikube](https://minikube.sigs.k8s.io/docs/) and [kubectl](https://kubernetes.io/docs/tasks/tools/).

```console
minikube start
```

Apply secrets and config maps:

```console
kubectl apply -f .kube/namespace.yaml
kubectl apply -f .kube/mysql-secret.yaml
kubectl apply -f .kube/php-secret.yaml
kubectl apply -f .
```

Start service:

```console
minikube service nginx-service -n cakephp-docker
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
