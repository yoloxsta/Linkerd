# Linkerd

- https://github.com/mehrdadrad/servicemesh-examples
- https://github.com/BuoyantIO/service-mesh-academy

```
- kubectl create ns demo4
- kubectl annotate namespace demo4 linkerd.io/inject=enabled

- kubectl run curl -n demo4 --rm -it --image=curlimages/curl -- sleep 3600
- kubectl exec -it -n demo4 curl -c curl -- sh

---
- kubectl get deploy -n demo -o yaml | linkerd inject - | kubectl apply -f -

- kubectl get deploy frontend -n demo -o yaml \
  | linkerd inject - \
  | kubectl apply -f -

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

## Install

```
Run this command to download the latest stable Linkerd CLI:

- curl -sL https://run.linkerd.io/install | sh


This will install the CLI into $HOME/.linkerd2/bin.

Add Linkerd to PATH

To make the linkerd command available, add it to your PATH:

- export PATH=$PATH:$HOME/.linkerd2/bin


To make this permanent for your playground session (until the environment resets), add it to .bashrc:

- echo 'export PATH=$PATH:$HOME/.linkerd2/bin' >> ~/.bashrc
- source ~/.bashrc

Verify Installation

Check the installed version:

- linkerd version

Then, 

1. Install Gateway API CRDs (required by Linkerd ≥ stable-2.14)
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml

2. Install Linkerd CRDs
linkerd install --crds | kubectl apply -f -

3. Install Linkerd Control Plane

(since the playground doesn’t allow running as non-root, add --set proxyInit.runAsRoot=true)

linkerd install --set proxyInit.runAsRoot=true | kubectl apply -f -

4. Verify Installation
linkerd check

```