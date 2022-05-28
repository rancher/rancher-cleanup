# Rancher resource cleanup script

**Warning**
```
THIS WILL DELETE ALL RESOURCES CREATED BY RANCHER
MAKE SURE YOU HAVE CREATED AND TESTED YOUR BACKUPS
THIS IS A NON REVERSIBLE ACTION
```

This script will delete all Kubernetes resources belonging to/created by Rancher (including installed tools like logging/monitoring/opa gatekeeper/etc). Note: this does not remove any Longhorn resources.

## Using the cleanup script

### Run as a Kubernetes Job

* Deploy the job using `kubectl create -f deploy/rancher-cleanup.yaml`
* Watch logs using `kubectl  -n kube-system logs -l job-name=cleanup-job  -f`

## Verify

* Deploy the job using `kubectl create -f deploy/verify.yaml`
* Watch logs using `kubectl  -n kube-system logs -l job-name=verify-job  -f`, output should be empty (besides deprecation warnings)
* Check completed logs using `kubectl  -n kube-system logs -l job-name=verify-job  -f | grep -v "is deprecated"`, this will exclude deprecation warnings.
