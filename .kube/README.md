# Kubernetes

You can run kubernetes locally with an orchestration tool such as [minikube](https://minikube.sigs.k8s.io/docs/) and
[kubectl](https://kubernetes.io/docs/tasks/tools/).

```console
minikube start
```

Apply [mysql-secret.yaml](mysql-secret.yaml) and [php-fpm-secret.yaml](php-fpm-secret.yaml).

```console
kubectl apply -f mysql-secret.yaml
kubectl apply -f php-fpm-secret.yaml
```

Apply deployments and services:

```console
kubectl apply -f .
```
