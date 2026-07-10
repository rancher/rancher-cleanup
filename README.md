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

### Excluding namespaces

Some namespaces in the default lists (such as `istio-system`) may also host non-Rancher workloads. Set the `EXCLUDE_NAMESPACES` environment variable to a space-separated list of namespaces that should be skipped during cleanup:

```
EXCLUDE_NAMESPACES="istio-system" bash cleanup.sh
```

When running as a Kubernetes Job, add it to the container `env`:

```yaml
env:
  - name: EXCLUDE_NAMESPACES
    value: "istio-system"
```

Excluded namespaces are removed from `CATTLE_NAMESPACES`, `TOOLS_NAMESPACES`, and `FLEET_NAMESPACES` before deletion.


## Verify

* Deploy the job using `kubectl create -f deploy/verify.yaml`
* Watch logs using `kubectl  -n kube-system logs -l job-name=verify-job  -f`, output should be empty (besides deprecation warnings)
* Check completed logs using `kubectl  -n kube-system logs -l job-name=verify-job  -f | grep -v "is deprecated"`, this will exclude deprecation warnings.


## Developing

### How to Make a Release

Releases are done via github actions, and triggered by pushing a
tag to the remote that starts with `v`. There are two types of
releases: "pre" and "full" release. To make a prerelease, push a
tag that contains the string `rc` or `alpha` (for example, `v1.2.3-rc1`
or `v1.2.3-alpha1`). To make a full release, push a tag that does
not contain either of these strings (for example, `v1.2.3`).
