# Linkerd

- https://github.com/mehrdadrad/servicemesh-examples
- https://github.com/BuoyantIO/service-mesh-academy
- https://spacelift.io/blog/what-is-a-service-mesh
- https://medium.com/@megaurav25/exploring-the-linkerd-dashboard-via-ingress-with-essential-commands-ca85c9aea933

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

Install Linkerd Viz Extension

If you want to use the dashboard:

- linkerd viz install | kubectl apply -f -
- linkerd viz check


Then forward the dashboard:

- linkerd viz dashboard &

```
## Test on Minikube

```
kubectl -n emojivoto port-forward svc/web-svc 8080:80
kubectl -n linkerd-viz port-forward svc/web 8084:8084
ssh -L 8080:127.0.0.1:8080 ubuntu@34.226.155.18
ssh -L 8084:127.0.0.1:8084 ubuntu@34.226.155.18

```
## Linkerd On EKS
```
Expose Linkerd Viz UI at:

https://sta-api.xyz.com


without port-forward and without the DNS rebinding error.

STEP 1 — Edit the Linkerd Viz Web Deployment

Run this exact command:

kubectl edit deployment web -n linkerd-viz

STEP 2 — Find the -enforced-host line

Scroll until you see this exact block:

containers:
- args:
  - -linkerd-metrics-api-addr=metrics-api.linkerd-viz.svc.cluster.local:8085
  - -cluster-domain=cluster.local
  - -controller-namespace=linkerd
  - -log-level=info
  - -log-format=plain
  - -enforced-host=^(localhost|127\.0\.0\.1|web\.linkerd-viz\.svc\.cluster\.local|web\.linkerd-viz\.svc|\[::1\])(:\d+)?$
  - -enable-pprof=false

STEP 3 — Replace ONLY this line
❌ OLD
- -enforced-host=^(localhost|127\.0\.0\.1|web\.linkerd-viz\.svc\.cluster\.local|web\.linkerd-viz\.svc|\[::1\])(:\d+)?$

✅ NEW (copy-paste exactly)
- -enforced-host=^(localhost|127\.0\.0\.1|web\.linkerd-viz\.svc\.cluster\.local|web\.linkerd-viz\.svc|sta-api\.xyz\.com|\[::1\])(:\d+)?$


👉 Do not change anything else

STEP 4 — Save and exit

vim: ESC → :wq → Enter

nano: Ctrl+O → Enter → Ctrl+X

Kubernetes will automatically restart the pod.

STEP 5 — Wait for rollout

Run:

kubectl rollout status deployment web -n linkerd-viz


You should see:

deployment "web" successfully rolled out

STEP 6 — Confirm pod restarted
kubectl get pods -n linkerd-viz


You should see AGE reset (new pod).

STEP 7 — Open in browser

Visit:

https://sta-api.xyz.com


✅ Linkerd Viz UI loads
```
