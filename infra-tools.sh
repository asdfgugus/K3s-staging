#!/bin/bash
# set new admin password
read -s -p "ArgoCD password: " ARGO_NEW_PW

# update already existing helm repos
helm repo update

# install cilium
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.14.3  --values values/cilium.yaml -n kube-system --wait
kubectl apply -f templates/cilium-network-policies

# install metallb
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb -n metallb-system --create-namespace --wait
kubectl apply -f templates/metallb


# install argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm install argo-cd argo/argo-cd --version 6.7.3 --values values/argocd.yaml -n argocd --create-namespace --wait

# configure argocd
ARGOCD_DEFAULT_PW=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
ARGOCD_IP=$(kubectl -n argocd get service argo-cd-argocd-server -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
argocd login $ARGOCD_IP --username admin --password $ARGOCD_DEFAULT_PW --insecure
argocd account update-password --account admin --current-password $ARGOCD_DEFAULT_PW --new-password $ARGO_NEW_PW
argocd proj create infra
argocd proj add-source infra https://github.com/asdfgugus/K3s-ArgoCD-apps.git
argocd proj add-destination infra "https://kubernetes.default.svc" "*"
argocd proj allow-cluster-resource infra "*" "*"
argocd proj role create infra allow-all
argocd proj role add-policy infra allow-all --action "*" --object "*" --permission allow

# deploy apps via argocd
argocd app create applications --repo https://github.com/asdfgugus/K3s-ArgoCD-apps.git --path applications --dest-server https://kubernetes.default.svc --dest-namespace argocd --sync-policy auto --sync-option Prune=true

# configure argocd for workload
argocd proj create workload
argocd proj add-source workload https://github.com/asdfgugus/K3s-ArgoCD-apps.git
argocd proj add-destination workload "https://kubernetes.default.svc" "*"
argocd proj allow-cluster-resource workload "*" "*"
argocd proj role create workload allow-all
argocd proj role add-policy workload allow-all --action "*" --object "*" --permission allow



export ARGO_NEW_PW=""