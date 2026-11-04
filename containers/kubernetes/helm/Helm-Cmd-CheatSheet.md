# Helm Command Cheat Sheet


# Helm Commands Quick Reference

| Command                                                            | Description                                                             |
|--------------------------------------------------------------------|-------------------------------------------------------------------------|
| `helm create mychart`                                              | Create a new Helm chart scaffold with standard files and templates.     |
| `helm lint mychart`                                                | Validate the chart and identify configuration or syntax issues.         |
| `helm template myapp ./mychart`                                    | Render Kubernetes manifests locally without deploying them.             |
| `helm template myapp ./mychart -f values-dev.yaml`                 | Render manifests using custom environment-specific values.              |
| `helm install myapp ./mychart`                                     | Deploy a new release of the chart to the current Kubernetes cluster.    |
| `helm install myapp ./mychart -f values-prod.yaml`                 | Deploy a new release using production-specific configuration values.    |
| `helm install myapp ./mychart --namespace prod --create-namespace` | Deploy the release into a specific namespace, creating it if necessary. |
| `helm list`                                                        | List Helm releases in the current namespace.                            |
| `helm list -A`                                                     | List Helm releases across all namespaces.                               |
| `helm status myapp`                                                | View the current status of a deployed Helm release.                     |
| `helm get values myapp`                                            | Display the values used by an installed release.                        |
| `helm get manifest myapp`                                          | Show the actual Kubernetes manifests deployed by Helm.                  |
| `helm history myapp`                                               | Display all deployment revisions for a release.                         |
| `helm upgrade myapp ./mychart`                                     | Update an existing release with changes from the chart.                 |
| `helm upgrade myapp ./mychart -f values-prod.yaml`                 | Update an existing release using specific configuration values.         |
| `helm rollback myapp 1`                                            | Revert a release to a previous revision.                                |
| `helm uninstall myapp`                                             | Remove a release and all resources managed by it.                       |
| `helm package ./mychart`                                           | Package the chart as a versioned `.tgz` archive.                        |
| `helm dependency update`                                           | Download and update chart dependencies defined in `Chart.yaml`.         |
| `helm show chart ./mychart`                                        | Display chart metadata such as name, description, and version.          |
| `helm show values ./mychart`                                       | Display the chart's default configuration values.                       |
| `helm repo add bitnami https://charts.bitnami.com/bitnami`         | Add a remote Helm chart repository.                                     |
| `helm repo update`                                                 | Refresh local metadata for configured chart repositories.               |
| `helm search repo nginx`                                           | Search configured repositories for charts matching a keyword.           |

---

## Helm Lifecycle at a Glance

| Phase    | Command                         | Purpose                                     |
|----------|---------------------------------|---------------------------------------------|
| Create   | `helm create mychart`           | Generate a chart skeleton.                  |
| Validate | `helm lint mychart`             | Verify chart correctness.                   |
| Preview  | `helm template myapp ./mychart` | See the generated Kubernetes YAML.          |
| Deploy   | `helm install myapp ./mychart`  | Deploy the application to Kubernetes.       |
| Update   | `helm upgrade myapp ./mychart`  | Apply chart changes to an existing release. |
| Verify   | `helm status myapp`             | Check deployment state and health.          |
| Rollback | `helm rollback myapp 1`         | Revert to a previous release version.       |
| Remove   | `helm uninstall myapp`          | Delete the release and managed resources.   |

---


## Create a New Chart

```bash
helm create mychart
```

Creates a new Helm chart skeleton with sample templates, values, and chart metadata.

---

## Validate a Chart

```bash
helm lint mychart
```

Checks the chart for syntax errors, missing fields, and common best-practice violations.

---

## Render Templates Locally

```bash
helm template myapp ./mychart
```

Generates the Kubernetes manifests locally without deploying them to a cluster.

---

## Render Templates with Environment-Specific Values

```bash
helm template myapp ./mychart -f values-dev.yaml
```

Renders the final YAML using values from `values-dev.yaml`.

Useful for verifying what will actually be deployed.

---

## Install a Chart

```bash
helm install myapp ./mychart
```

Deploys the chart to the current Kubernetes cluster and namespace.

---

## Install with Custom Values

```bash
helm install myapp ./mychart -f values-prod.yaml
```

Deploys the chart using production-specific configuration values.

---

## Install into a Specific Namespace

```bash
helm install myapp ./mychart \
  --namespace prod \
  --create-namespace
```

Creates the namespace if needed and deploys the release there.

---

## List Installed Releases

```bash
helm list
```

Shows all Helm releases in the current namespace.

### List Across All Namespaces

```bash
helm list -A
```

Shows all Helm releases in the cluster.

---

## Check Release Status

```bash
helm status myapp
```

Displays deployment status, resources, and release information.

---

## View Values Used by a Release

```bash
helm get values myapp
```

Shows the values that were used during installation or upgrade.

---

## View Generated Manifests

```bash
helm get manifest myapp
```

Displays the exact Kubernetes YAML deployed by Helm.

---

## Upgrade an Existing Release

```bash
helm upgrade myapp ./mychart
```

Updates an existing deployment with chart changes.

---

## Upgrade with Custom Values

```bash
helm upgrade myapp ./mychart -f values-prod.yaml
```

Updates the deployment while applying a specific values file.

---

## View Release History

```bash
helm history myapp
```

Displays all revisions and deployment history for a release.

---

## Roll Back a Release

```bash
helm rollback myapp 1
```

Restores the release to revision 1.

---

## Uninstall a Release

```bash
helm uninstall myapp
```

Removes the Helm release and deletes its Kubernetes resources.

---

## Package a Chart

```bash
helm package ./mychart
```

Creates a distributable `.tgz` package from the chart.

Example output:

```text
mychart-0.1.0.tgz
```

---

## Update Chart Dependencies

```bash
helm dependency update
```

Downloads and updates any dependent charts specified in `Chart.yaml`.

---

## View Chart Metadata

```bash
helm show chart ./mychart
```

Displays chart information such as name, version, description, and maintainers.

---

## View Default Values

```bash
helm show values ./mychart
```

Displays the default values that the chart uses.

---

## Add a Helm Repository

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Registers a remote Helm repository.

---

## Update Repository Metadata

```bash
helm repo update
```

Downloads the latest chart information from configured repositories.

---

## Search for Available Charts

```bash
helm search repo nginx
```

Searches configured repositories for charts matching "nginx".

---

# Typical Helm Workflow

## 1. Create a Chart

```bash
helm create myapp
```

## 2. Validate the Chart

```bash
helm lint myapp
```

## 3. Preview Generated Kubernetes Manifests

```bash
helm template myapp ./myapp -f values-dev.yaml
```

## 4. Deploy to Kubernetes

```bash
helm install myapp ./myapp -f values-dev.yaml
```

## 5. Make Changes and Redeploy

```bash
helm upgrade myapp ./myapp -f values-dev.yaml
```

## 6. Verify Deployment

```bash
helm status myapp
```

## 7. Remove the Application

```bash
helm uninstall myapp
```

---

# Helm Mental Model

```text
helm create
    ↓
Create chart template

helm template
    ↓
Preview generated YAML

helm install
    ↓
Deploy application

helm upgrade
    ↓
Update application

helm rollback
    ↓
Undo deployment

helm uninstall
    ↓
Remove application
```

---

# Helm Terminology

| Term       | Meaning                                                    |
|------------|------------------------------------------------------------|
| Chart      | Reusable package containing Kubernetes templates           |
| Values     | Environment-specific configuration injected into templates |
| Release    | A deployed instance of a chart                             |
| Repository | Storage location for Helm charts                           |
| Template   | Kubernetes YAML with placeholders                          |
| Namespace  | Kubernetes logical grouping where resources are created    |

### Example

```text
Chart      = Application template
Values     = Environment-specific inputs
Release    = Running deployment
Cluster    = Kubernetes environment
Namespace  = Logical location within cluster
```

One chart can be deployed multiple times with different values:

```bash
helm install myapp-dev  ./mychart -f values-dev.yaml
helm install myapp-qa   ./mychart -f values-qa.yaml
helm install myapp-prod ./mychart -f values-prod.yaml
```

This results in three separate releases using the same chart but different configurations.

