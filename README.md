# Linkerd

- https://github.com/mehrdadrad/servicemesh-examples

```
- kubectl create ns demo4
- kubectl annotate namespace demo4 linkerd.io/inject=enabled

- kubectl run curl -n demo4 --rm -it --image=curlimages/curl -- sleep 3600
- kubectl exec -it -n demo4 curl -c curl -- sh

---

Install Gateway API CRDs

Run this in your cluster:

kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v0.7.1/standard-install.yaml

(You can replace v0.7.1 with the latest release).

---
- Disable for a single namespace

If you enabled injection at the namespace level:

- kubectl annotate namespace demo4 linkerd.io/inject=disabled --overwrite

- linkerd uninstall | kubectl delete -f -

```