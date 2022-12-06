#!/bin/bash
# Overridden on package
SCRIPT_VERSION="unreleased"
echo "Running verify.sh version ${SCRIPT_VERSION}"

kcg()
{
  kubectl get --ignore-not-found=true "$@"
}

kcg -n cattle-system deploy,ds
kcg -n kube-system configmap cattle-controllers
kcg mutatingwebhookconfigurations -o name | grep cattle\.io
kcg mutatingwebhookconfigurations -o name | grep rancher-monitoring
kcg mutatingwebhookconfigurations -o name | grep istio
kcg mutatingwebhookconfigurations -o name | grep mutating-webhook-configuration

kcg validatingwebhookconfigurations -o name | grep cattle\.io
kcg validatingwebhookconfigurations -o name | grep rancher-monitoring
kcg validatingwebhookconfigurations -o name | grep gatekeeper
kcg validatingwebhookconfigurations -o name | grep istio
kcg validatingwebhookconfigurations -o name | grep validating-webhook-configuration

kcg apiservice -o name | grep cattle\.io | grep -v k3s\.cattle\.io | grep -v helm\.cattle\.io
kcg apiservice -o name | grep istio
kcg apiservice -o name | grep gatekeeper
kcg apiservice -o name | grep custom\.metrics\.k8s\.io
kcg apiservice -o name | grep elemental

kcg clusterrolebinding -l cattle.io/creator=norman
kcg clusterrolebinding --no-headers -o custom-columns=NAME:.metadata.name | grep ^cattle-
kcg clusterrolebinding --no-headers -o custom-columns=NAME:.metadata.name | grep rancher 
kcg clusterrolebinding --no-headers -o custom-columns=NAME:.metadata.name | grep ^fleet-
kcg clusterrolebinding --no-headers -o custom-columns=NAME:.metadata.name | grep ^gitjob
kcg clusterrolebinding --no-headers -o custom-columns=NAME:.metadata.name | grep ^pod-impersonation-helm
kcg clusterrolebinding --no-headers -o custom-columns=NAME:.metadata.name | grep ^gatekeeper
kcg clusterrolebinding --no-headers -o custom-columns=NAME:.metadata.name | grep ^cis
kcg clusterrolebinding --no-headers -o custom-columns=NAME:.metadata.name | grep ^istio
kcg clusterrolebinding --no-headers -o custom-columns=NAME:.metadata.name | grep ^elemental

kcg clusterroles -l cattle.io/creator=norman
kcg clusterroles --no-headers -o custom-columns=NAME:.metadata.name | grep ^cattle-
kcg clusterroles --no-headers -o custom-columns=NAME:.metadata.name | grep rancher
kcg clusterroles --no-headers -o custom-columns=NAME:.metadata.name | grep ^fleet
kcg clusterroles --no-headers -o custom-columns=NAME:.metadata.name | grep ^gitjob
kcg clusterroles --no-headers -o custom-columns=NAME:.metadata.name | grep ^pod-impersonation-helm
kcg clusterroles --no-headers -o custom-columns=NAME:.metadata.name | grep ^logging-
kcg clusterroles --no-headers -o custom-columns=NAME:.metadata.name | grep ^monitoring-
kcg clusterroles --no-headers -o custom-columns=NAME:.metadata.name | grep ^gatekeeper
kcg clusterroles --no-headers -o custom-columns=NAME:.metadata.name | grep ^cis
kcg clusterroles --no-headers -o custom-columns=NAME:.metadata.name | grep ^istio
kcg clusterroles --no-headers -o custom-columns=NAME:.metadata.name | grep ^elemental

kcg podsecuritypolicy -o name -l app.kubernetes.io/name=rancher-logging
kcg podsecuritypolicy.policy/rancher-logging-rke-aggregator

kcg podsecuritypolicy -o name -l release=rancher-monitoring
kcg podsecuritypolicy -o name -l app=rancher-monitoring-crd-manager
kcg podsecuritypolicy -o name -l app=rancher-monitoring-patch-sa
kcg podsecuritypolicy -o name -l app.kubernetes.io/instance=rancher-monitoring

kcg podsecuritypolicy -o name -l release=rancher-gatekeeper
kcg podsecuritypolicy -o name -l app=rancher-gatekeeper-crd-manager

kcg podsecuritypolicy -o name -l app.kubernetes.io/name=rancher-backup
kcg podsecuritypolicy -o name | grep istio-installer
kcg podsecuritypolicy -o name | grep istio-psp
kcg podsecuritypolicy -o name | grep kiali-psp
kcg podsecuritypolicy -o name | grep psp-istio-cni

kcg namespace -o name | grep "^cattle"
kcg namespace -o name | grep "rancher-operator-system"
kcg namespace -o name | grep "cis-operator-system"
kcg namespace -o name | grep "^c-"
kcg namespace -o name | grep "^p-"
kcg namespace -o name | grep "^user-"
kcg namespace -o name | grep "^u-"
kcg namespace -o name | grep "fleet"
kcg namespace -o name | grep "istio"
kcg namespace -o name | grep "elemental"

kcg "$(kubectl api-resources --namespaced=true --verbs=delete -o name | grep logging\.banzaicloud\.io | tr "\n" "," | sed -e 's/,$//')" -A --no-headers -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,KIND:.kind,APIVERSION:.apiVersion 2>/dev/null
kcg "$(kubectl api-resources --namespaced=true --verbs=delete -o name | grep -v events\.events\.k8s\.io | grep -v ^events$ | tr "\n" "," | sed -e 's/,$//')" -A --no-headers -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,KIND:.kind,APIVERSION:.apiVersion | grep rancher-monitoring 2>/dev/null
kcg "$(kubectl api-resources --namespaced=true --verbs=delete -o name | grep monitoring\.coreos\.com | tr "\n" "," | sed -e 's/,$//')" -A --no-headers -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,KIND:.kind,APIVERSION:.apiVersion 2>/dev/null
kcg "$(kubectl api-resources --namespaced=true --verbs=delete -o name | grep gatekeeper\.sh | tr "\n" "," | sed -e 's/,$//')" -A --no-headers -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,KIND:.kind,APIVERSION:.apiVersion 2>/dev/null
kcg "$(kubectl api-resources --namespaced=true --verbs=delete -o name | grep cluster\.x-k8s\.io | tr "\n" "," | sed -e 's/,$//')" -A --no-headers -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,KIND:.kind,APIVERSION:.apiVersion 2>/dev/null

kubectl api-resources --namespaced=false --verbs=delete -o name| grep logging\.banzaicloud\.io | tr "\n" "," | sed -e 's/,$//'
kubectl api-resources --namespaced=false --verbs=delete -o name| grep gatekeeper\.sh | tr "\n" "," | sed -e 's/,$//'

kcg crd | grep cattle\.io | grep -v helm\.cattle\.io | grep -v k3s\.cattle\.io
kcg crd | grep logging\.banzaicloud\.io
kcg crd | grep monitoring\.coreos\.com
kcg crd | grep gatekeeper\.sh
kcg crd | grep istio\.io
kcg crd | grep cluster\.x-k8s\.io

kcg configmap -A | grep istio-ca-root-cert

kubectl api-resources --namespaced=true --verbs=delete -o name | grep cattle\.io | grep -v helm\.cattle\.io | grep -v k3s\.cattle\.io | tr "\n" "," | sed -e 's/,$//'
kubectl api-resources --namespaced=false --verbs=delete -o name| grep cattle\.io | tr "\n" "," | sed -e 's/,$//'
